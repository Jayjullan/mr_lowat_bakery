import 'package:flutter/material.dart';

class OrderTracker extends StatelessWidget {
  final List<OrderStepData> steps;

  const OrderTracker({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        return Column(
          children: [
            _buildOrderStep(steps[index]),
            if (index < steps.length - 1) // Don't add divider after last step
              _buildVerticalDivider(steps[index].isCompleted),
          ],
        );
      }),
    );
  }

  Widget _buildOrderStep(OrderStepData step) {
    return Row(
      children: [
        Icon(
          step.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: step.isCompleted ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 10),
        Text(
          step.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: step.isCompleted ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(bool isActive) {
    return Container(
      height: 30,
      width: 2,
      color: isActive ? Colors.green : Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 15),
    );
  }
}

class OrderStepData {
  final String title;
  final bool isCompleted;

  OrderStepData({required this.title, required this.isCompleted});
}

// Example usage:
class ExampleUsage extends StatelessWidget {
  const ExampleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    List<OrderStepData> orderSteps = [
      OrderStepData(title: "Payment Completed", isCompleted: true),
      OrderStepData(title: "Order Accepted", isCompleted: true),
      OrderStepData(title: "Order Processing", isCompleted: true),
      OrderStepData(title: "Ready for Pickup", isCompleted: false),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracker Example')),
      body: Center(
        child: OrderTracker(steps: orderSteps),
      ),
    );
  }
}