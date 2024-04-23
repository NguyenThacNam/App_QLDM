import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class DanhMuc {
  String name;
  int id;
  List<String>
      details; // Thêm một danh sách để lưu trữ thông tin chi tiết của mỗi mục

  DanhMuc(this.name, this.id, this.details);
}

class DanhMucListViewModel extends ChangeNotifier {
  List<DanhMuc> _danhMucs = [
    DanhMuc('Hoc tap', 1, ['8h - Hoc van', '15h - Hoc toan']),
    DanhMuc(
        'Choi game', 2, ['Buoi sang - Game mobile', 'Buoi chieu - Game PC']),
    DanhMuc('An uong', 3, ['7h - An sang', '12h - An trua', '18h - An toi']),
    DanhMuc('Nghi ngoi', 4, ['Du lich', 'Nghe nhac', 'Doc sach']),
  ];

  List<DanhMuc> get danhMucs => _danhMucs;

  void addDanhMuc(String danhMucName, List<String> danhMucDetails) {
    int newId = _danhMucs.isNotEmpty ? _danhMucs.last.id + 1 : 1;
    _danhMucs.add(DanhMuc(danhMucName, newId, danhMucDetails));
    notifyListeners();
  }

  void removeDanhMuc(int id) {
    _danhMucs.removeWhere((danhMuc) => danhMuc.id == id);
    notifyListeners();
  }

  void updateDanhMuc(int id, String newName, List<String> newDetails) {
    _danhMucs.firstWhere((danhMuc) => danhMuc.id == id).name = newName;
    _danhMucs.firstWhere((danhMuc) => danhMuc.id == id).details = newDetails;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DanhMucListViewModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DanhMucListView(),
      ),
    );
  }
}

class DanhMucListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Mục'),
      ),
      body: Consumer<DanhMucListViewModel>(
        builder: (context, danhMucListViewModel, child) {
          return ListView.builder(
            itemCount: danhMucListViewModel.danhMucs.length,
            itemBuilder: (context, index) {
              final danhMuc = danhMucListViewModel.danhMucs[index];
              return ListTile(
                leading: Text('${index + 1}'),
                title: Text('${danhMuc.name}'),
                subtitle: Text('Nhấn để xem chi tiết'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    danhMucListViewModel.removeDanhMuc(danhMuc.id);
                  },
                ),
                onTap: () {
                  _showDetailsDialog(context, danhMucListViewModel, danhMuc);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context,
              Provider.of<DanhMucListViewModel>(context, listen: false));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(
      BuildContext context, DanhMucListViewModel danhMucListViewModel) {
    String newDanhMucName = '';
    String newDanhMucDetails = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm Danh Mục'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newDanhMucName = value;
                },
                decoration: InputDecoration(hintText: 'Nhập tên danh mục'),
              ),
              TextField(
                onChanged: (value) {
                  newDanhMucDetails = value;
                },
                decoration: InputDecoration(hintText: 'Nhập chi tiết danh mục'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                if (newDanhMucName.isNotEmpty && newDanhMucDetails.isNotEmpty) {
                  danhMucListViewModel
                      .addDanhMuc(newDanhMucName, [newDanhMucDetails]);
                }
                Navigator.of(context).pop();
              },
              child: Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  void _showDetailsDialog(BuildContext context,
      DanhMucListViewModel danhMucListViewModel, DanhMuc danhMuc) {
    List<String> updatedDetails = List.from(danhMuc.details);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _controller =
            TextEditingController(text: danhMuc.details.join('\n'));
        return AlertDialog(
          title: Text('Chi tiết Danh Mục'),
          content: TextField(
            controller: _controller,
            onChanged: (value) {
              updatedDetails = value.split('\n');
            },
            maxLines: null,
            decoration: InputDecoration(hintText: 'Nhập chi tiết danh mục mới'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                danhMucListViewModel.updateDanhMuc(
                    danhMuc.id, danhMuc.name, updatedDetails);
                Navigator.of(context).pop();
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}
