import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class Site extends StatefulWidget {
  const Site({super.key});

  @override
  State<Site> createState() => _SiteState();
}

class _SiteState extends State<Site> {

  InAppWebViewController? controller;
  late PullToRefreshController pullToRefreshController;


  String url = "https://www.google.com/";

  @override
  final List<String> bookmarks = [];

  void initState() {
    // TODO: implement initState
    pullToRefreshController = PullToRefreshController(
      onRefresh: ()
          {
            controller?.reload();
          }
    );
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff202125),
        title: Text('Browser App'),
        elevation: 0,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert,color: Colors.white,),
            itemBuilder: (context){
              return [
                PopupMenuItem(
                    child: TextButton.icon(
                        onPressed: () {
                         openBookmark();
                        },
                        icon: Icon(Icons.bookmark_add_outlined,color: Colors.black,),
                        label: Text('All Bookmark',style: TextStyle(color: Colors.black),))),
                PopupMenuItem(
                    child: TextButton.icon(
                        onPressed: (){ },
                        icon: Icon(Icons.search_rounded,color: Colors.black,),
                        label: Text('Search Engine',style: TextStyle(color: Colors.black),))),
              ];
            },
          )


        ],
      ),
      body: InAppWebView(
            pullToRefreshController: pullToRefreshController,
            onWebViewCreated: (abc) {
              controller = abc;
            },
            initialUrlRequest: URLRequest(
                url: Uri.parse(url),
            ),
            onProgressChanged: (controller, progress) {
              if (progress == 100)
                {
                  pullToRefreshController.endRefreshing();
                }
            },
          ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        backgroundColor: Colors.green,
        items: [
          BottomNavigationBarItem(
              icon: IconButton(color: Colors.white,
                  onPressed: () async {
                await controller?.loadUrl(urlRequest: URLRequest(url: Uri.parse(url)) );
                  },
                  icon: Icon(Icons.home_outlined,)), label: '',
              backgroundColor: Color(0xff202125)),
          BottomNavigationBarItem(
              icon: IconButton(color: Colors.white,
                  onPressed: () {
                      addFavoriteLink(context);
                      },
                  icon: Icon(Icons.bookmark_add_outlined,)), label: ''),
          BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () async {
                    if((
                    await controller?.canGoBack()
                    )?? false)
                      {
                        await controller?.goBack();
                      }
                    },
                   child: Icon(Icons.arrow_back_ios,color: Colors.white,)),label: ''),
          BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () {
                    controller?.reload();
                    },
                  child: Icon(Icons.refresh,color: Colors.white,)),label: ''),
          BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () async {
                    if((
                        await controller?.canGoForward()
                    )?? false)
                    {
                      await controller?.goForward();
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios,color: Colors.white,)),label: ''),
            ]
          )
      );
  }
}

final List<String> bookmarks = [];
InAppWebViewController? controller;


void addFavoriteLink(BuildContext context) async {
  final String? newLink = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('Add Favorite Link'),
        children: <Widget>[
          TextField(
              onSubmitted: (link)async {
                Navigator.pop(context, link);
                final String? title = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: Text('add'),
                        children: [
                          TextField(
                            onSubmitted: (bookmarkTitle) {
                              Navigator.pop(context, bookmarkTitle);

                            },
                          )
                        ],
                      );
                    }
                );
              }
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () async{
              Navigator.pop(context);
              Uri? url = await controller?.getUrl();
              if (url != null) {
                bookmarks.add(url.toString());
              }
            },
          ),
        ],
      );
    },
  );
}
void saveBookmark(String link) {
  bookmarks.add(link);
}
void openBookmark() async{
  var context;
  final selectedBookmark = await showDialog<String>(
      context: context,
      builder: (BuildContext context){
        return SimpleDialog(
          title: Text('selected bookmark'),
          children: bookmarks.map((e) => SimpleDialogOption(
            onPressed: (){
              Navigator.pop(context, bookmarks);
            },
            child: Text(e),
          )).toList(),
        );
      });
  if(selectedBookmark != null){
    await controller?.loadUrl(urlRequest: URLRequest(
        url: Uri.parse(selectedBookmark)
    ));
  }
}


