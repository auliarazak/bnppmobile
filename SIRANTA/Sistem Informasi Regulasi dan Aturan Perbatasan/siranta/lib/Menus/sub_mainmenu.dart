import 'package:flutter/material.dart';
import 'package:siranta/Berita/Edit/list_edit_berita.dart';
import 'package:siranta/Berita/list_berita.dart';
import 'package:siranta/Paparan/Edit/list_edit_paparan.dart';
import 'package:siranta/Paparan/list_paparan.dart';
import 'package:siranta/Peraturans/Edit/list_edit_peraturan.dart';
import 'package:siranta/Peraturans/list_peraturan.dart';
import 'package:siranta/ProdukSetup/list_produk_setup.dart';

class SubMenu extends StatefulWidget {
  final String backgroundImage;
  final String menuTitle;

  const SubMenu(
      {super.key, required this.backgroundImage, required this.menuTitle});

  @override
  State<SubMenu> createState() => _SubMenuState();
}

class _SubMenuState extends State<SubMenu> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> _tabTitles;
  Color _backgroundColor = Colors.blue.shade50;
  Color _backgroundTitleColor = Colors.blue.shade50;
  late Map<String, String> _tabFullNames;

  @override
  void initState() {
    super.initState();
    _initializeMenuContent();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {}); // This will trigger a rebuild to show/update the full name
  }

  void _initializeMenuContent() {
    // Initialize _tabFullNames with an empty map by default
    _tabFullNames = {};

    switch (widget.menuTitle) {
      case 'Kebijakan Pengelolaan \nPerbatasan Negara':
        _tabTitles = [
          'UU',
          'PERPRES',
          'INPRES',
          'PP',
          'PERMEN',
          'PBNPP',
          'PKBNPP',
          'PERDA',
          'PB',
          'MoU',
          'LAIN'
        ];
        _tabFullNames = {
          'UU': 'Undang Undang',
          'PERPRES': 'Peraturan Presiden',
          'INPRES': 'Instruksi Presiden',
          'PP': 'Peraturan Pemerintah',
          'PERMEN': 'Peraturan Menteri',
          'PBNPP': 'Peraturan BNPP',
          'PKBNPP': 'Peraturan Kepala BNPP',
          'PERDA': 'Peraturan Daerah',
          'PB': 'Peraturan Biro',
          'MoU': 'Naskah Kesepahaman',
          'LAIN': 'Peraturan Lainnya'
        };
        _backgroundColor = const Color(0xFFFCF8EF);
        _backgroundTitleColor = const Color.fromARGB(255, 252, 249, 243);
        break;
      case 'Paparan dan Surat Penting':
        _tabTitles = ['PPKA', 'PBWNKP', 'DI', 'FKSDLN', 'LAIN', 'SSP'];
        _tabFullNames = {
          'PPKA': 'Perencanaan Program Kegiatan dan Anggaran',
          'PBWNKP': 'Pengelolaan Batas Wilayah Negara dan Kawasan Perbatasan',
          'DI': 'Data dan Informasi',
          'FKSDLN': 'Fasilitas Kerja Sama Dalam dan Luar Negeri',
          'LAIN': 'Paparan Lainnya',
          'SSP': 'Surat Surat Penting'
        };
        _backgroundColor = const Color(0xFFCAE6F1);
        _backgroundTitleColor = const Color.fromARGB(255, 206, 226, 235);
        break;
      case 'Produk Setup BNPP':
        _tabTitles = ['PPBWNKP', 'Panduan'];
        _tabFullNames = {
          'PPBWNKP':
              'Potret Pengelolaan Batas Wilayah Negara dan Kawasan Perbatasan',
          'Panduan': 'Panduan'
        };
        _backgroundColor = const Color(0xFF77B3CD);
        _backgroundTitleColor = const Color.fromARGB(255, 210, 242, 255);
        break;
      case 'Berita':
        _tabTitles = ['Terbaru', 'Terlama', 'A-Z'];
        _tabFullNames = {
          'Terbaru': 'Berita Terbaru',
          'Terlama': 'Berita Terlama',
          'A-Z': 'Berita Berurutan A-Z',
          'Z-A': 'Berita Berurutan Z-A'
        };
        _backgroundColor = const Color(0xFFFADA7A);
        _backgroundTitleColor = const Color.fromARGB(255, 252, 228, 158);
        break;
      case 'Pengaturan Data':
        _tabTitles = ['Peraturan', 'Paparan', 'Produk', 'Berita'];
        _tabFullNames = {
          'Peraturan': 'Pengaturan Peraturan',
          'Paparan': 'Pengaturan Paparan',
          'Produk': 'Pengaturan Produk',
          'Berita': 'Pengaturan Berita'
        };
        _backgroundColor = const Color(0xFFF9C0AB);
        _backgroundTitleColor = const Color.fromARGB(255, 248, 206, 191);
        break;
      default:
        _tabTitles = [];
        _backgroundColor = Colors.blue.shade50;
        _backgroundTitleColor = Colors.blue.shade50;
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade50,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: false,
                pinned: true,
                snap: false,
                automaticallyImplyLeading:
                    true, // Ensures back button is always visible
                expandedHeight: 120.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: widget.backgroundImage,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          widget.backgroundImage,
                          fit: BoxFit.cover,
                        ),
                        Center(
                          child: Text(
                            widget.menuTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: Colors.blue.shade900,
                    labelColor: Colors.blue.shade900,
                    unselectedLabelColor: Colors.black54,
                    tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
                  ),
                  _backgroundColor,
                ),
                pinned: true,
              ),
              // New SliverToBoxAdapter to show full name
              SliverToBoxAdapter(
                child: Container(
                  color:
                      _backgroundTitleColor, // Use the background title color here
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ValueListenableBuilder(
                    valueListenable: _tabController.index.obs(),
                    builder: (context, index, child) {
                      return Text(
                        _tabFullNames[_tabTitles[index]] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: _tabTitles.map((tab) {
              if (widget.menuTitle ==
                  'Kebijakan Pengelolaan \nPerbatasan Negara') {
                return ListPeraturan(
                    selectedTab: tab,
                    menuType: 'Kebijakan Pengelolaan Perbatasan Negara');
              } else if (widget.menuTitle == 'Paparan dan Surat Penting') {
                return ListPaparan(
                    selectedTab: tab, menuType: 'Paparan dan Surat Penting');
              } else if (widget.menuTitle == 'Produk Setup BNPP') {
                return ListProdukSetup(
                    selectedTab: tab, menuType: 'Produk Setup BNPP');
              } else if (widget.menuTitle == 'Berita') {
                return const ListBerita();
              } else if (widget.menuTitle == 'Pengaturan Data') {
                switch (tab) {
                  case 'Peraturan':
                    return const ListEditPeraturan();
                  case 'Paparan':
                    return const ListEditPaparan();
                  case 'Produk':
                    // return const ListEditProduk();
                  case 'Berita':
                    return const ListEditBerita();
                  default:
                    return Center(
                      child: Text(
                        'Detail $tab untuk ${widget.menuTitle}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                }
              }

              return Center(
                child: Text(
                  'Detail $tab untuk ${widget.menuTitle}',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

extension on int {
  ValueNotifier<int> obs() => ValueNotifier(this);
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color _backgroundColor;

  _SliverAppBarDelegate(this._tabBar, this._backgroundColor);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: _backgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
