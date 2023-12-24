from flask import Flask, request, jsonify
from PIL import Image
import pytesseract
import re
import sqlite3
import cv2
import numpy as np

ocr_result = None

# Database initialization function
def initialize_database():
    conn = sqlite3.connect('ocr_results.db')
    cursor = conn.cursor()

    # Create a table if it doesn't exist
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS ocr_results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            NIK TEXT,
            Nama TEXT,
            Alamat TEXT
        )
    ''')

    conn.commit()
    conn.close()

# Initialize the SQLite database
initialize_database()

# Function to save the OCR result to the database
def save_to_database(ocr_result):
    conn = sqlite3.connect('ocr_results.db')
    cursor = conn.cursor()

    # Insert the OCR result into the database
    cursor.execute('''
        INSERT INTO ocr_results (NIK, Nama, Alamat)
        VALUES (?, ?, ?)
    ''', (ocr_result['NIK'], ocr_result['Nama'], ocr_result['Alamat']))

    conn.commit()
    conn.close()


def word_to_number_converter(word):
    word_dict = {
        "L" : "1",
        'l' : "1",
        'O' : "0",
        'o' : "0",
        '?' : "7",
        'b' : "6",
        'B' : "8",
        'S' : "5",
        's' : "5",
    }

    res = ''
    for letter in word:
        if letter in word_dict:
            res += word_dict[letter]
        else:
            res += letter
    return res


def extract_nik(section_text):
    # Apply normalization
    normalized_text = word_to_number_converter(section_text)
    match = re.search(r'\b[731]\d{15}\b', normalized_text)
    if match:
        return match.group(0)
    else:
        print("Data NIK tidak ditemukan")
    
def extract_address(text):
    keywords = ["JL", "DSN", "GANG", "KOTA", "KABUPATEN", "PROVINSI" ]
    address = ""

    for keyword in keywords:
        match = re.search(keyword + '.*', text)
        if match:
            address += match.group(0) + " "

    if address:
        return address.strip()
    else:
        return "Data alamat tidak ditemukan"


def extract_name(text):
    # Cari pola Nama pada KTP dan berhenti ketika menemukan "Tempat/Tgl Lahir" atau "Jenis Kelamin"
    regex = r"Nama\s+(.+?)(?=Tempat/Tgl Lahir|Jenis Kelamin)"
    match = re.search(regex, text, re.DOTALL)

    # Jika ditemukan, kembalikan Nama
    if match:
        return match.group(1).strip()
    else:
        # Jika tidak ditemukan, cari 1-4 kata dalam bentuk uppercase semua setelah "Nama"
        regex_uppercase = r"Nama \s+((?:[A-Z]+\s*){1,4})"
        match_uppercase = re.search(regex_uppercase, text)
        if match_uppercase:
            return match_uppercase.group(1).strip()
        else:
            return 'Data nama tidak ditemukan'
    



    
app = Flask(__name__)

@app.route('/upload', methods=['POST'])
def upload_file():
    global ocr_result
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected for uploading'}), 400

    # Read the image file into a numpy array
    npimg = np.fromfile(file, np.uint8)

    # Convert the numpy array to an image
    original_image = cv2.imdecode(npimg, cv2.IMREAD_COLOR)

    # Apply preprocessing steps
    gray = cv2.cvtColor(original_image, cv2.COLOR_BGR2GRAY)
    _, thresholded = cv2.threshold(gray, 100, 255, cv2.THRESH_BINARY)

    # Convert the preprocessed image to PIL format
    image = Image.fromarray(thresholded)

    text = pytesseract.image_to_string(image)


    section_keywords = ["NIK", "Nama", "Alamat"]
    sections_data = {}

    # Map each keyword to its corresponding function
    keyword_to_function = {
        "NIK": extract_nik,
        "Nama": extract_name,
        "Alamat": extract_address
    }

    for keyword in section_keywords:
        # Get the corresponding function for this keyword
        extract_function = keyword_to_function[keyword]

        # Call the function with the text as argument
        section_text = extract_function(text)

        # Store the result in the sections_data dictionary
        sections_data[keyword] = section_text

    ocr_result = sections_data
    save_to_database(ocr_result)

    return jsonify(ocr_result)

@app.route('/display_results', methods=['GET'])
def display_results():
    conn = sqlite3.connect('ocr_results.db')
    cursor = conn.cursor()

    # Retrieve all OCR results from the database
    cursor.execute('SELECT * FROM ocr_results')
    rows = cursor.fetchall()

    # Convert the data to a list of dictionaries
    data = [{'NIK': row[1], 'Nama': row[2], 'Alamat': row[3]} for row in rows]

    conn.close()

    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True,port=5005)
