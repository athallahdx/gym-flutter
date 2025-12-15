import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/core/errors/app_exception.dart';
import 'package:gym_app/app/data/models/transaction.dart';
import 'package:gym_app/app/data/repositories/transaction_repository.dart';

// Events
class TransactionInitial {}
class LoadTransactions {}

// States
class TransactionLoading {}
class TransactionsLoaded {
  final List<Transaction> transactions;
  TransactionsLoaded(this.transactions);
}
class TransactionError {
  final String message;
  TransactionError(this.message);
}

// Bloc
class TransactionBloc extends Bloc<Object, Object> {
  final TransactionRepository transactionRepository;

  TransactionBloc({required this.transactionRepository})
      : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<Object> emit,
  ) async {
    print('🔄 TransactionBloc: Loading transactions...');
    emit(TransactionLoading());

    try {
      final transactions = await transactionRepository.getTransactions();
      print('✅ TransactionBloc: Loaded ${transactions.length} transactions');
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      // Extract just the message part without the prefix wrapper
      String errorMessage = e.toString();
      if (e is AppException) {
        errorMessage = e.message;
      }
      print('❌ TransactionBloc error: $errorMessage');
      emit(TransactionError(errorMessage));
    }
  }
}
