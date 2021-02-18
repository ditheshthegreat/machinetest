import 'package:ditheshv/model/repos.dart';
import 'package:ditheshv/repo/user_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoryView extends StatefulWidget {
  final String repoUrl;

  const RepositoryView({Key key, this.repoUrl}) : super(key: key);

  @override
  _RepositoryViewState createState() => _RepositoryViewState();
}

class _RepositoryViewState extends State<RepositoryView> {
  UserCubit _userCubit = UserCubit();

  @override
  void didChangeDependencies() {
    _userCubit.getRepos(widget.repoUrl);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _userCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        cubit: _userCubit,
        builder: (context, snapshot) {
          if (snapshot is UserLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot is RepoResponse) {
            return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.reposDetailsModel.length,
                itemBuilder: (context, index) {
                  ReposDetailsModel _repos = snapshot.reposDetailsModel[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    child: ListTile(
                      onTap: () async {
                        if (await canLaunch(_repos.htmlUrl)) {
                          launch(_repos.htmlUrl);
                        }
                      },
                      isThreeLine: true,
                      title: Text(
                        _repos.name,
                        style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.blue),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8.0,
                          ),
                          Visibility(
                              visible: _repos.description != null,
                              child: Text(
                                "${_repos.description}",
                                maxLines: 3,
                                style: TextStyle(color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              )),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: [
                              Text("Update on ${DateFormat("MMM dd yyyy").format(_repos.updatedAt)}"),
                              Visibility(
                                  visible: _repos.language != null,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Icon(
                                        Icons.language,
                                        size: 16.0,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                      Text(" ${_repos.language}"),
                                    ],
                                  )),
                              _repos.forksCount != 0
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Icon(
                                          CupertinoIcons.tuningfork,
                                          size: 16.0,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                        Text(" ${_repos.forksCount}"),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            if (snapshot is UserError) {
              return Center(
                child: Text(snapshot.error.message),
              );
            }
            return Center(
              child: Text("Something went wrong please try again."),
            );
          }
        });
  }
}
