part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserError extends UserState {
  final RestException error;

  UserError(this.error);

  @override
  List<Object> get props => [error];
}

class UserResponse extends UserState {
  final UserDetailsModel userDetailsModel;

  UserResponse(this.userDetailsModel);

  @override
  List<Object> get props => [userDetailsModel];
}
class RepoResponse extends UserState {
  final List<ReposDetailsModel> reposDetailsModel;

  RepoResponse(this.reposDetailsModel);

  @override
  List<Object> get props => [reposDetailsModel];
}
