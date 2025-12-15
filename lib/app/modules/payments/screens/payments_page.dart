import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/data/repositories/transaction_repository.dart';
import 'package:gym_app/app/modules/payments/bloc/transaction_bloc.dart';
import 'package:gym_app/app/modules/payments/screens/midtrans_payment_page.dart';
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
      backgroundColor: const Color(0xFFF4F4F5),
      appBar: AppBar(
        title: const Text('Transaction History', style: TextStyle(fontWeight: FontWeight.w600)),
        automaticallyImplyLeading: false,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.black.withOpacity(0.05),
            height: 1,
          ),
        ),
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
                    state.message,
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
    Color statusBgColor;
    IconData statusIcon;
    String statusText;

    switch (transaction.paymentStatus.toLowerCase()) {
      case 'pending':
        statusColor = const Color(0xFFF59E0B);
        statusBgColor = const Color(0xFFFEF3C7);
        statusIcon = Icons.hourglass_empty;
        statusText = 'PENDING';
        break;
      case 'paid':
      case 'success':
        statusColor = const Color(0xFF16A34A);
        statusBgColor = const Color(0xFFDCFCE7);
        statusIcon = Icons.check_circle;
        statusText = 'PAID';
        break;
      case 'failed':
      case 'cancelled':
        statusColor = const Color(0xFFDC2626);
        statusBgColor = const Color(0xFFFEE2E2);
        statusIcon = Icons.cancel;
        statusText = 'FAILED';
        break;
      default:
        statusColor = const Color(0xFF71717A);
        statusBgColor = const Color(0xFFF4F4F5);
        statusIcon = Icons.info;
        statusText = transaction.paymentStatus.toUpperCase();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            _showTransactionDetails(context, transaction);
          },
          borderRadius: BorderRadius.circular(16),
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
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
                                color: Color(0xFF18181B),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(8),
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
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F4F5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.fitness_center,
                              size: 14,
                              color: Color(0xFF71717A),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              transaction.purchasableType == 'gym_class'
                                  ? 'Gym Class'
                                  : transaction.purchasableType == 'membership'
                                      ? 'Membership'
                                      : transaction.purchasableType,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF52525B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F4F5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Color(0xFF71717A),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dateFormat.format(transaction.createdAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF71717A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    Text(
                      currencyFormat.format(transaction.amount),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Right side - Arrow
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF71717A),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    )
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
                          onPressed: () async {
                            Navigator.pop(context); // Close bottom sheet first
                            
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MidtransPaymentPage(
                                  snapToken: transaction.snapToken!,
                                  transactionCode: transaction.code,
                                ),
                              ),
                            );

                            // Handle payment result
                            if (result != null) {
                              final status = result['status'];
                              final message = result['message'];
                              
                              Color backgroundColor;
                              if (status == 'success') {
                                backgroundColor = Colors.green;
                              } else if (status == 'pending') {
                                backgroundColor = Colors.orange;
                              } else {
                                backgroundColor = Colors.red;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: backgroundColor,
                                ),
                              );

                              // Refresh transaction list
                              context.read<TransactionBloc>().add(LoadTransactions());
                            }
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
