import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crashassist/common/widgets/primary_button.dart';
import 'package:crashassist/common/widgets/secondary_button.dart';
import 'package:crashassist/common/widgets/custom_text_field.dart';
import 'package:crashassist/common/widgets/card_tile.dart';
import 'package:crashassist/common/widgets/step_progress_indicator.dart';
import 'package:crashassist/common/widgets/section_header.dart';
import 'package:crashassist/features/report_accident/presentation/providers/report_provider.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('renders with text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Loading',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Disabled',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });
  });

  group('SecondaryButton', () {
    testWidgets('renders as outlined button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              text: 'Secondary',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Secondary'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });

  group('CustomTextField', () {
    testWidgets('renders with label and hint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Email',
              hint: 'Enter email',
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('shows validation error', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomTextField(
                label: 'Name',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Required'), findsOneWidget);
    });
  });

  group('CardTile', () {
    testWidgets('renders with title and icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardTile(
              title: 'Test Card',
              icon: Icons.car_crash,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Card'), findsOneWidget);
      expect(find.byIcon(Icons.car_crash), findsOneWidget);
    });

    testWidgets('shows check when selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardTile(
              title: 'Selected Card',
              icon: Icons.car_crash,
              isSelected: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });

  group('StepProgressIndicator', () {
    testWidgets('renders correct number of dots', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StepProgressIndicator(
              totalSteps: 3,
              currentStep: 1,
            ),
          ),
        ),
      );

      // Should render 3 AnimatedContainer widgets for dots
      expect(find.byType(AnimatedContainer), findsNWidgets(3));
    });
  });

  group('SectionHeader', () {
    testWidgets('renders title and action', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Section Title',
              actionText: 'See All',
              onActionTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Section Title'), findsOneWidget);
      expect(find.text('See All'), findsOneWidget);
    });
  });

  group('ReportProvider', () {
    test('initial state', () {
      final provider = ReportProvider();
      expect(provider.selectedAccidentType, isNull);
      expect(provider.capturedPhotos, isEmpty);
      expect(provider.locationText, 'Amman, Jordan');
      expect(provider.fullName, isEmpty);
      expect(provider.isAccidentTypeSelected, isFalse);
    });

    test('setAccidentType updates value', () {
      final provider = ReportProvider();
      provider.setAccidentType('Minor Collision');
      expect(provider.selectedAccidentType, 'Minor Collision');
      expect(provider.isAccidentTypeSelected, isTrue);
    });

    test('addPhoto and removePhoto', () {
      final provider = ReportProvider();
      provider.addPhoto('photo1');
      provider.addPhoto('photo2');
      expect(provider.capturedPhotos.length, 2);
      expect(provider.hasPhotos, isTrue);

      provider.removePhoto(0);
      expect(provider.capturedPhotos.length, 1);
    });

    test('setDriverDetails stores data', () {
      final provider = ReportProvider();
      provider.setDriverDetails(
        fullName: 'John Doe',
        phoneNumber: '+962700000000',
        vehiclePlateNumber: 'ABC123',
        insuranceCompany: 'Test Insurance',
        accidentDescription: 'Minor fender bender',
      );
      expect(provider.fullName, 'John Doe');
      expect(provider.phoneNumber, '+962700000000');
      expect(provider.vehiclePlateNumber, 'ABC123');
      expect(provider.hasDriverDetails, isTrue);
    });

    test('resetReport clears all data', () {
      final provider = ReportProvider();
      provider.setAccidentType('Minor Collision');
      provider.addPhoto('photo1');
      provider.setDriverDetails(
        fullName: 'John',
        phoneNumber: '123',
        vehiclePlateNumber: 'ABC',
        insuranceCompany: 'Ins',
        accidentDescription: 'Desc',
      );

      provider.resetReport();

      expect(provider.selectedAccidentType, isNull);
      expect(provider.capturedPhotos, isEmpty);
      expect(provider.fullName, isEmpty);
      expect(provider.isAccidentTypeSelected, isFalse);
    });
  });
}
