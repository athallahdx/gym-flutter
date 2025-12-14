import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/data/models/membership_package.dart';
import 'package:gym_app/app/data/repositories/membership_repository.dart';

// Events
class LoadMembershipPackages {}

class LoadMembershipPackageDetail {
  final int packageId;
  LoadMembershipPackageDetail(this.packageId);
}

class PurchaseMembershipPackage {
  final String packageId;
  PurchaseMembershipPackage(this.packageId);
}

class LoadCurrentMembership {}

// States
class MembershipInitial {}

class MembershipLoading {}

class MembershipPackagesLoaded {
  final List<MembershipPackage> packages;
  final Map<String, dynamic>? currentMembership;
  MembershipPackagesLoaded(this.packages, this.currentMembership);
}

class MembershipPackageDetailLoaded {
  final MembershipPackage package;
  MembershipPackageDetailLoaded(this.package);
}

class MembershipPurchaseInProgress {}

class MembershipPurchaseSuccess {
  final String message;
  MembershipPurchaseSuccess(this.message);
}

class MembershipError {
  final String message;
  MembershipError(this.message);
}

// Bloc
class MembershipBloc extends Bloc<Object, Object> {
  final MembershipRepository membershipRepository;

  MembershipBloc({required this.membershipRepository})
    : super(MembershipInitial()) {
    on<LoadMembershipPackages>(_onLoadMembershipPackages);
    on<LoadMembershipPackageDetail>(_onLoadMembershipPackageDetail);
    on<PurchaseMembershipPackage>(_onPurchaseMembershipPackage);
    on<LoadCurrentMembership>(_onLoadCurrentMembership);
  }

  Future<void> _onLoadMembershipPackages(
    LoadMembershipPackages event,
    Emitter<Object> emit,
  ) async {
    print('🔄 MembershipBloc: Loading membership packages...');
    emit(MembershipLoading());
    try {
      final packages = await membershipRepository.getMembershipPackages();
      final currentMembership = await membershipRepository
          .getCurrentMembership();

      print('✅ MembershipBloc: Loaded ${packages.length} packages');
      emit(MembershipPackagesLoaded(packages, currentMembership));
    } catch (e) {
      print('❌ MembershipBloc error: $e');
      emit(MembershipError(e.toString()));
    }
  }

  Future<void> _onLoadMembershipPackageDetail(
    LoadMembershipPackageDetail event,
    Emitter<Object> emit,
  ) async {
    emit(MembershipLoading());
    try {
      final package = await membershipRepository.getMembershipPackageDetail(
        event.packageId,
      );
      emit(MembershipPackageDetailLoaded(package));
    } catch (e) {
      emit(MembershipError(e.toString()));
    }
  }

  Future<void> _onPurchaseMembershipPackage(
    PurchaseMembershipPackage event,
    Emitter<Object> emit,
  ) async {
    emit(MembershipPurchaseInProgress());
    try {
      final result = await membershipRepository.purchaseMembership(
        event.packageId,
      );
      emit(
        MembershipPurchaseSuccess(
          result['message'] ?? 'Membership purchased successfully',
        ),
      );
      add(LoadMembershipPackages());
    } catch (e) {
      emit(MembershipError(e.toString()));
    }
  }

  Future<void> _onLoadCurrentMembership(
    LoadCurrentMembership event,
    Emitter<Object> emit,
  ) async {
    try {
      final currentMembership = await membershipRepository
          .getCurrentMembership();

      if (state is MembershipPackagesLoaded) {
        final currentState = state as MembershipPackagesLoaded;
        emit(
          MembershipPackagesLoaded(currentState.packages, currentMembership),
        );
      }
    } catch (e) {
      // Silently fail
    }
  }
}
