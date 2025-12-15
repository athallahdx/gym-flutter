import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/core/errors/app_exception.dart';
import 'package:gym_app/app/data/repositories/dashboard_repository.dart';

// Events
class LoadDashboard {}

// States
class DashboardInitial {}

class DashboardLoading {}

class DashboardLoaded {
  final Map<String, dynamic> summary;
  final Map<String, dynamic> data;

  DashboardLoaded(this.summary, this.data);
}

class DashboardError {
  final String message;
  DashboardError(this.message);
}

// Bloc
class DashboardBloc extends Bloc<Object, Object> {
  final DashboardRepository dashboardRepository;

  DashboardBloc({required this.dashboardRepository})
    : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<Object> emit,
  ) async {
    print('🔄 DashboardBloc: Loading dashboard data...');
    emit(DashboardLoading());
    try {
      final response = await dashboardRepository.getDashboardData();

      // The API returns: { status: "success", data: { summary: {...}, user: {...}, ... } }
      final dataWrapper = Map<String, dynamic>.from(
        response['data'] ?? <String, dynamic>{},
      );
      final summary = Map<String, dynamic>.from(
        dataWrapper['summary'] ?? <String, dynamic>{},
      );
      final data = Map<String, dynamic>.from(dataWrapper);

      print('✅ DashboardBloc: Loaded dashboard data');
      print(
        '📊 Summary: visitCountInCurrentMonth=${summary['visitCountInCurrentMonth']}, gymClassCount=${summary['gymClassCountInCurrentMonth']}',
      );
      emit(DashboardLoaded(summary, data));
    } catch (e) {
      // Extract just the message part without the prefix wrapper
      String errorMessage = e.toString();
      if (e is AppException) {
        errorMessage = e.message;
      }
      print('❌ DashboardBloc error: $errorMessage');
      emit(DashboardError(errorMessage));
    }
  }
}
