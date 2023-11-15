import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goconcert/pages/dashboard.dart';
import 'package:goconcert/pages/scan_page.dart';

// Kelas untuk merepresentasikan data konser
class Concert {
  final String category;
  final String title;
  final String price;
  final String date;
  final String location;
  final String eventDetails;
  final String banner;

  Concert({
    required this.category,
    required this.title,
    required this.price,
    required this.date,
    required this.location,
    required this.eventDetails,
    required this.banner,
  });
}

class TicketDetails extends StatelessWidget {
  final String concertName;
  final List<Concert> concerts = [
    Concert(
      category: 'K-Pop',
      title: 'NewJeans',
      price: 'Rp5.000.000 / orang',
      date: '14 January 2024',
      location: 'Jakarta International Stadium (JIS)',
      eventDetails:
          'Kami dengan senang hati mengumumkan bahwa konser pertama NEWJEANS akan diadakan di Indonesia di Jakarta International Stadium pada 15 Januari 2024. Penggemar dapat membeli tiket presale mulai 1 Desember 2023.',
      banner: 'NewJeans-banner.png',
    ),
    Concert(
      category: 'K-Pop',
      title: 'Le Sserafim',
      price: 'Rp4.500.000 / orang',
      date: '24 March 2024',
      location: 'Stadion Gelora Bung Karno',
      eventDetails:
          'Grup K-Pop Le Sserafim konser di Jakarta pada 24 March 2024. Konser tersebut digelar di Stadion Gelora Bung Karno. Dikutip Hallyu Idol, Le Sserafim beranggota lima orang naungan agensi Source Music. Debut mereka pada 2 Mei 2022 dengan mini album pertama Fearless.',
      banner: 'LeSserafim-banner.png',
    ),
    Concert(
      category: 'Pop',
      title: 'Coldplay',
      price: 'Rp2.500.000 / orang',
      date: '15 November 2023',
      location: 'Stadion Gelora Bung Karno',
      eventDetails:
          'Coldplay, band asal Inggris yang dibentuk pada 1996 di London, akan menyelenggarakan konser di Stadion Utama Gelora Bung Karno (GBK) Jakarta besok, Rabu, 15 November 2023. Konser mereka kali ini bertajuk Music of The Spheres World Tour 2023.',
      banner: 'Coldplay-banner.png',
    ),
    Concert(
      category: 'Rock',
      title: 'Bring Me The Horizon',
      price: 'Rp5.500.000 / orang',
      date: '10 November 2023',
      location: 'Beach City, Ancol, Jakarta',
      eventDetails:
          'Band metalcore asal Sheffield, Inggris, Bring Me The Horizon (BMTH) siap menyapa para penggemar Indonesia melalui konser tunggalnya pada 10 November 2023 mendatang. Konser tur Oliver Sykes dan kawan-kawan ini akan digelar di Beach City Internasional Stadium Ancol, Jakarta.',
      banner: 'bmth-banner.png',
    ),
  ];

  TicketDetails({required this.concertName});

  @override
  Widget build(BuildContext context) {
    // Mencari konser berdasarkan nama
    Concert? selectedConcert = concerts.firstWhere(
      (concert) => concert.title == concertName,
      orElse: () => Concert(
        category: '',
        title: '',
        price: '',
        date: '',
        location: '',
        eventDetails: '',
        banner: '',
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Container untuk latar belakang
          Container(
            alignment: Alignment.topCenter,
            child: selectedConcert != null
                ? Image.asset(
                    '../assets/img/${selectedConcert.banner}',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  )
                : Container(),
          ),

          Positioned(
            top: 80.0,
            left: 30.0,
            right: 30.0,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardWidget(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Back',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Heart Icon
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.heart,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Container 3 - Concert Information
          Positioned(
            top: 420.0,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              padding: EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: const Color(0xFF251F4F),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                      selectedConcert?.category ?? '', 12.0, FontWeight.normal),
                  _buildSectionTitle(selectedConcert?.title ?? ''),
                  _buildInfoRow(
                      selectedConcert?.price ?? '', 16.0, FontWeight.bold),
                  _buildInfoRowWithIcon(
                    selectedConcert?.date ?? '',
                    FontAwesomeIcons.calendar,
                    12.0,
                    FontWeight.normal,
                  ),
                  _buildInfoRowWithIcon(
                    selectedConcert?.location ?? '',
                    FontAwesomeIcons.map,
                    12.0,
                    FontWeight.bold,
                  ),
                  _buildSectionTitle('Event Details', fontSize: 16.0),
                  _buildSectionContent(selectedConcert?.eventDetails ?? ''),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 50.0,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Button - "Beli Tiket"
                  Container(
                    width: 370.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ScanPage(), // Ganti dengan halaman tujuan untuk membeli tiket
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF5E8C7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Beli Tiket', // Teks tombol "Beli Tiket"
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Text - "Tidak memiliki akun? Daftar"
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membuat baris informasi
  Widget _buildInfoRow(String value, double fontSize, FontWeight fontWeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        value,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

// Fungsi untuk membuat baris informasi dengan ikon
  Widget _buildInfoRowWithIcon(
      String value, IconData iconData, double fontSize, FontWeight fontWeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.white,
            size: 14.0,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: fontWeight,
              ),
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

// Fungsi untuk membuat judul bagian
  Widget _buildSectionTitle(String title, {double fontSize = 20.0}) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

// Fungsi untuk membuat konten bagian
  Widget _buildSectionContent(String content) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        content,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.0,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
