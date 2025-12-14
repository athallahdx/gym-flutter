import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/data/repositories/transaction_repository.dart';
import 'package:gym_app/app/modules/payments/bloc/transaction_bloc.dart';
import 'package:intl/intl.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionBloc(
        transactionRepository: TransactionRepository(),
      )..add(LoadTransactions()),
      child: const PaymentsView(),
    );
  }
}

class PaymentsView extends StatelessWidget {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TransactionBloc>().add(LoadTransactions());
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, Object>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TransactionBloc>().add(LoadTransactions());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TransactionsLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No transactions yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TransactionBloc>().add(LoadTransactions());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = state.transactions[index];
                  return _buildTransactionCard(context, transaction);
                },
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, dynamic transaction) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (transaction.paymentStatus.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        statusText = 'PENDING';
        break;
      case 'paid':
      case 'success':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'PAID';
        break;
      case 'failed':
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'FAILED';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
        statusText = transaction.paymentStatus.toUpperCase();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showTransactionDetails(context, transaction);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side - Icon and status
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // Middle - Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            transaction.code,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            transaction.purchasableType == 'gym_class'
                                ? 'Gym Class'
                                : transaction.purchasableType == 'membership'
                                    ? 'Membership'
                                    : transaction.purchasableType,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(transaction.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormat.format(transaction.amount),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Right side - Arrow
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, dynamic transaction) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Transaction Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  _buildDetailRow('Transaction Code', transaction.code),
                  _buildDetailRow('Type', transaction.purchasableType == 'gym_class' ? 'Gym Class' : 'Membership'),
                  _buildDetailRow('Amount', currencyFormat.format(transaction.amount)),
                  _buildDetailRow('Status', transaction.paymentStatus.toUpperCase()),
                  _buildDetailRow('Created', dateFormat.format(transaction.createdAt)),
                  if (transaction.paymentDate != null)
                    _buildDetailRow('Payment Date', dateFormat.format(transaction.paymentDate!)),
                  const Divider(height: 32),
                  if (transaction.snapToken != null && transaction.paymentStatus == 'pending')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Open Midtrans payment with snap_token
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Payment integration coming soon!'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Continue Payment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
