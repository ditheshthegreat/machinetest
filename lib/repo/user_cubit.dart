import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:ditheshv/model/repos.dart';
import 'package:ditheshv/model/user.dart';
import 'package:ditheshv/rest/app_exceptions.dart';
import 'package:ditheshv/rest/rest_api.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void getUser(String username) async {
    emit(UserLoading());
    try {
      Map<String, dynamic> res = await RestAPI().get<Map<String,dynamic>>(APis.getUser(username));
      emit(UserResponse(UserDetailsModel.fromJson(res)));
    } on RestException catch (e) {
      emit(UserError(e));
    }
    
  }
  void getRepos(String url)async{
    emit(UserLoading());
    try {
     var res = await RestAPI().get<List<dynamic>>(url);
      emit(RepoResponse(reposDetailsModelFromJson(json.encode(res))));
    } on RestException catch (e) {
      emit(UserError(e));
    }
  }
}
