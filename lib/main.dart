import 'package:ditheshv/repo/user_cubit.dart';
import 'package:ditheshv/view/repository_view.dart';
import 'package:ditheshv/view/user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Github'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserCubit _userCubit = UserCubit();

  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Github User Search');
  final TextEditingController _filter = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: _buildBar(context),
          body: BlocBuilder(
              cubit: _userCubit,
              builder: (context, snapshot) {
                if (snapshot is UserInitial) {
                  return Center(
                    child: Text(
                      "Search a username to show details",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  );
                }
                if (snapshot is UserLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot is UserResponse) {
                  return TabBarView(
                    children: [
                      UserView(
                        userDetailsModel: snapshot.userDetailsModel,
                      ),
                      RepositoryView(
                        repoUrl: snapshot.userDetailsModel.reposUrl,
                      ),
                    ],
                  );
                } else {
                  if (snapshot is UserError) {
                    return Center(
                      child: Text(
                        "${snapshot.error.message}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    );
                  }
                  return Center(
                    child: Text("Something went wrong please try again."),
                  );
                }
              })),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          style: TextStyle(color: Colors.white),
          decoration: new InputDecoration(
              prefixIcon: new Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: 'Search username',
              hintStyle: TextStyle(color: Colors.white)),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            if (value.isNotEmpty) _userCubit.getUser("$value");
          },
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Github User Search');
        _filter.clear();
      }
    });
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: _appBarTitle,
      actions: [
        IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        )
      ],
      bottom: TabBar(
        tabs: [
          Tab(
            text: "Profile",
          ),
          Tab(
            text: "Repositories",
          ),
        ],
      ),
    );
  }
}
