
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
  final List<String> bookmarks = [];

  String url = "https://www.google.com/";

  @override
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
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'option1') {
                // Show a BottomSheet for Option 1
                showBottomSheet(context);
              } else if (value == 'option2') {
                // Show a BottomSheet for Option 2
                showBottomSheet(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'option1',
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.bookmark,color: Colors.black,),
                        onPressed: () {

                        },
                      ),
                      SizedBox(width: 5,),
                      Text('All Bookmarks'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'option2',
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.search_rounded,color: Colors.black,),
                        onPressed: () {

                        },
                      ),
                      SizedBox(width: 5,),
                      Text('Search Engine'),
                    ],
                  ),
                ),
              ];
            },
          ),
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
void showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Text('This is a Bottom Sheet'),
      );
    },
  );
}

