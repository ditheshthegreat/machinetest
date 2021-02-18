import 'package:ditheshv/model/user.dart';
import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  final UserDetailsModel userDetailsModel;

  const UserView({Key key, this.userDetailsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        SizedBox(height:32.0),
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: FadeInImage(
                fit: BoxFit.cover,
                width: 200,
                height: 200,
                placeholder: AssetImage("assets/user_image.png"),
                image: NetworkImage(userDetailsModel.avatarUrl),
              ),
            ),
          ],
        ),
        ListTile(
          isThreeLine: true,
          title: Visibility(
            child: Text(
              "${userDetailsModel?.name??"No Name"}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          subtitle: Text(
            "${userDetailsModel.login}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Table(
          children: [
            TableRow(children: [
              ListTile(
                title: Text(
                  "${userDetailsModel.followers}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
                subtitle: Text(
                  "Followers",
                  textAlign: TextAlign.center,
                ),
              ),
              ListTile(
                title: Text(
                  "${userDetailsModel.following}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
                subtitle: Text(
                  "Following",
                  textAlign: TextAlign.center,
                ),
              ),
              ListTile(
                title: Text(
                  "${userDetailsModel.publicRepos}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
                subtitle: Text(
                  "Repositories",
                  textAlign: TextAlign.center,
                ),
              ),
            ])
          ],
        )
      ],
    );
  }
}
