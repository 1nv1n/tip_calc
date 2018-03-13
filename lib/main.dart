import 'package:flutter/material.dart';

// Main App
void main() => runApp(new App());

// App Name
String appName = "Yet Another Tip Calculator";

// Text Resources
String billedAmountString = "Billed Amount";
String tipPercentageString = "Tip (0-100\%)";
String totalAmountString = "Total Amount";
String tipAmountString = "Tip Amount";
String resetString = "R E S E T";

String defaultTipPercentageString = "15";

String invalidBilledAmountString = "Invalid Billed Amount!";
String invalidTipPercentageString = "Invalid Tip Percentage!";
String invalidTotalAmountString = "Invalid Total Amount!";
String invalidTipTotalString = "Invalid Tip Total! ";

String billAmountLessThanZeroString = "Bill Amount < 0.0 !";

/*
 Root widget of the application.
 MaterialApp builds a "Material" home.
*/
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        // App Title
        title: appName,
        // App's primary theme & cursor color
        theme: new ThemeData(
            primarySwatch: Colors.amber, textSelectionColor: Colors.black),
        home: new AppContainer(title: appName));
  }
}

// Stateless App Container
class AppContainer extends StatelessWidget {
  AppContainer({Key key, this.title}) : super(key: key);

  // App title
  final String title;

  // Instance of the input & calculated fields
  final CalculatorFields calcFields = new CalculatorFields();

  // Build the App
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // 'App Bar' for the application
        appBar: new AppBar(
            title: new Text(title),
            // This removes the blurred bottom-line of the AppBar
            elevation: 1.0),
        backgroundColor: Colors.white,
        body: new Column(
          // Column's children consist two rows, one for the inputs & one for the reset button.
          children: <Widget>[
            new Flexible(child: new InputFieldWidget(calcFields: calcFields)),
            new Flexible(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[new ResetWidget(calcFields: calcFields)],
              ),
            ),
          ],
        ));
  }
}

// Widget that holds all the input fields
class InputFieldWidget extends StatefulWidget {
  InputFieldWidget({Key key, this.calcFields}) : super(key: key);

  // Reference to the to the calculator fields instance
  final CalculatorFields calcFields;

  // Create InputWidget's state
  @override
  _InputFieldWidgetState createState() =>
      new _InputFieldWidgetState(calcFields);
}

// Holds the content & state of the input fields
class _InputFieldWidgetState extends State<InputFieldWidget> {
  _InputFieldWidgetState(this.calcFields);

  // Reference to the to the calculator fields instance
  CalculatorFields calcFields;

  // Input TextFields
  TextField billedAmountField;
  TextField tipPercentageField;
  TextField totalAmountTextField;
  TextField tipAmountTextField;

  // Method is re-run every time setState is called
  @override
  Widget build(BuildContext context) {
    // Set the default tip percentage on build
    calcFields.tipPercentageFieldController.text = defaultTipPercentageString;

    // 2x2 GridView of the Inputs
    return new GridView.count(
      primary: true,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      shrinkWrap: true,
      childAspectRatio: 2.0,
      mainAxisSpacing: 20.0,
      crossAxisSpacing: 40.0,
      crossAxisCount: 2,
      children: <Widget>[
        billedAmountField = new TextField(
            controller: calcFields.billAmountFieldController,
            autocorrect: false,
            autofocus: true,
            maxLines: 1,
            decoration: new InputDecoration(labelText: billedAmountString),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (String value) {
              try {
                // Set the Billed Amount for a valid input
                if (double.parse(value) >= 0.0) {
                  calcFields.setBilledAmount(double.parse(value));
                } else {
                  if (double.parse(value) < 0.0) {
                    invalidBillAmount(billAmountLessThanZeroString);
                  } else {
                    invalidBillAmount(invalidBilledAmountString);
                  }
                }
              } catch (exception) {
                invalidBillAmount(invalidBilledAmountString);
              }
            }),
        tipPercentageField = new TextField(
            controller: calcFields.tipPercentageFieldController,
            autocorrect: false,
            maxLines: 1,
            decoration: new InputDecoration(
              labelText: tipPercentageString,
              hintText: defaultTipPercentageString,
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (String value) {
              try {
                // Tip percentage can range from [0-100], both inclusive
                if (double.parse(value) >= 0.0 &&
                    double.parse(value) <= 100.0) {
                  calcFields.setTipPercentage(double.parse(value));
                } else {
                  invalidTipPercentage();
                }
              } catch (exception) {
                invalidTipPercentage();
              }
            }),
        totalAmountTextField = new TextField(
            controller: calcFields.totalAmountFieldController,
            autocorrect: false,
            maxLines: 1,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              labelText: totalAmountString,
            ),
            onChanged: (String value) {
              try {
                if (double.parse(value) >= 0.0) {
                  calcFields.setTotalAmount(double.parse(value));
                } else {
                  invalidTotalAmount();
                }
              } catch (exception) {
                invalidTotalAmount();
              }
            }),
        tipAmountTextField = new TextField(
          controller: calcFields.tipAmountFieldController,
          autocorrect: false,
          maxLines: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: new InputDecoration(
            labelText: tipAmountString,
          ),
          onChanged: (String value) {
            try {
              if (double.parse(value) >= 0.0) {
                calcFields.setTipAmount(double.parse(value));
              } else {
                invalidTipAmount();
              }
            } catch (exception) {
              invalidTipAmount();
            }
          },
        )
      ],
    );
  }

  // Handle Invalid Billed Amount
  invalidBillAmount(String snackBarString) {
    // Invalid Billed Amount Snackbar notification
    Scaffold.of(context).showSnackBar(
        new SnackBar(content: new Text(snackBarString)));

    // Reset calculated amounts (Reset tip if invalid)
    calcFields.resetExceptTipPercentage();
  }

  // Handle Invalid Tip Percentage
  invalidTipPercentage() {
    // Invalid Tip Percentage Snackbar notification
    Scaffold.of(context).showSnackBar(
        new SnackBar(content: new Text(invalidTipPercentageString)));

    // Reset calculated amounts
    calcFields.resetCalculatedFields();
  }

  // Handle Invalid Total Amount
  invalidTotalAmount() {
    // Invalid Total Amount Snackbar notification
    Scaffold.of(context).showSnackBar(
        new SnackBar(content: new Text(invalidTotalAmountString)));

    // Reset calculated amounts
    calcFields.resetCalculatedFields();
  }

  // Handle Invalid Tip Amount
  invalidTipAmount() {
    // Invalid Tip Amount Snackbar notification
    Scaffold.of(context).showSnackBar(
        new SnackBar(content: new Text(invalidTipTotalString)));

    // Reset calculated amounts
    calcFields.resetCalculatedFields();
  }
}

// Widget that holds the Reset button
class ResetWidget extends StatelessWidget {
  ResetWidget({Key key, this.calcFields}) : super(key: key);

  // Ref. to the calculator fields
  final CalculatorFields calcFields;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new MaterialButton(
          color: Colors.amber,
          height: 60.0,
          minWidth: 360.0,
          child: new Text(resetString,
              textAlign: TextAlign.center,
              style: new TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () {
            // Reset to default
            calcFields.resetToDefault();
          }),
    );
  }
}

/*
 Class that contains all the fields the calculator relies upon
  as well as their respective editing Controllers.
*/
class CalculatorFields {
  // Tip Calculator Fields
  double billedAmount = 0.0;
  double totalAmount = 0.0;
  double tipAmount = 0.0;
  double tipPercentage = 0.0;

  // Text Editing Controllers
  TextEditingController billAmountFieldController;
  TextEditingController tipPercentageFieldController;
  TextEditingController totalAmountFieldController;
  TextEditingController tipAmountFieldController;

  // Constructor to initialize controllers & set defaults
  CalculatorFields() {
    tipPercentage = 15.0;

    billAmountFieldController = new TextEditingController();
    tipPercentageFieldController = new TextEditingController();
    totalAmountFieldController = new TextEditingController();
    tipAmountFieldController = new TextEditingController();
  }

  // Reset all input field values to their defaults
  resetToDefault() {
    billedAmount = 0.0;
    totalAmount = 0.0;
    tipAmount = 0.0;
    tipPercentage = 15.0;

    billAmountFieldController.clear();
    tipAmountFieldController.clear();
    totalAmountFieldController.clear();
    tipPercentageFieldController.text = defaultTipPercentageString;
  }

  // Reset all input field values to their defaults.
  // Reset the tip percentage only if it is invalid.
  resetExceptTipPercentage() {
    tipAmount = 0.0;
    totalAmount = 0.0;
    billedAmount = 0.0;

    tipAmountFieldController.clear();
    billAmountFieldController.clear();
    totalAmountFieldController.clear();

    if (tipPercentage < 0.0 || tipPercentage > 100.0) {
      tipPercentage = 15.0;
      tipPercentageFieldController.text = defaultTipPercentageString;
    }
  }

  // Reset only the calculated (Tip AMount & Total Amount) to defaults.
  resetCalculatedFields() {
    tipAmount = 0.0;
    totalAmount = 0.0;

    tipAmountFieldController.clear();
    totalAmountFieldController.clear();
  }

  // Set the calculated (Tip Amount & Total Amount) amounts.
  // The field values are expected to already be set.
  setCalculatedAmountsToController() {
    tipAmountFieldController.text = tipAmount.toString();
    totalAmountFieldController.text = totalAmount.toString();
  }

  // Set the calculated (Tip AMount & Total Amount) amounts.
  // The field values are expected to already be set.
  setTipValuesToController() {
    tipAmountFieldController.text = tipAmount.toString();
    tipPercentageFieldController.text = tipPercentage.toString();
  }

  // Set the user-input Billed Amount & attempt to calculate the other fields.
  setBilledAmount(double billedAmountToSet) {
    billedAmount = billedAmountToSet;

    // Totals can only be calculated if there's a valid tip percentage
    if (tipPercentage >= 0.0 && tipPercentage <= 100.0) {
      // If the Tip percentage is 0, the Tip Amount is also 0
      if (tipPercentage == 0.0) {
        tipAmount = 0.0;
      } else {
        if (billedAmount == 0.0) {
          tipAmount = (tipPercentage / 100.0);
        } else {
          tipAmount = billedAmount * (tipPercentage / 100.0);
        }
      }

      totalAmount = tipAmount + billedAmount;

      // Set calculated amounts
      setCalculatedAmountsToController();
    }
  }

  // Set the user-input Tip Percentage & attempt to calculate the other fields.
  setTipPercentage(double tipPercentageToSet) {
    tipPercentage = tipPercentageToSet;

    // Totals can only be calculated if there's a valid billed amount
    if (billedAmount >= 0.0) {
      // If the Tip percentage is 0, the Tip Amount is also 0
      if (tipPercentage == 0.0) {
        tipAmount = 0.0;
      } else {
        if (billedAmount == 0.0) {
          tipAmount = (tipPercentage / 100.0);
        } else {
          tipAmount = billedAmount * (tipPercentage / 100.0);
        }
      }

      totalAmount = tipAmount + billedAmount;

      // Set calculated amounts
      setCalculatedAmountsToController();
    }
  }

  // Set the user-input Total Amount & attempt to calculate the other fields.
  setTotalAmount(double totalAmountToSet) {
    totalAmount = totalAmountToSet;

    // If the Billed Amount is 0 or lesser than 0, the entire Total Amount is the Tip Amount
    // Otherwise the Tip Amount is the net between the Total & Billed Amount
    if (billedAmount <= 0.0) {
      tipAmount = totalAmount;
      tipPercentage = 100.0;
    } else {
      tipAmount = totalAmount - billedAmount;
      tipPercentage = (tipAmount / billedAmount) * 100.0;
    }

    // Set the Tip Amount & Percentage
    setTipValuesToController();
  }

  // Set the user-input Tip Amount & attempt to calculate the other fields.
  setTipAmount(double tipAmountToSet) {
    tipAmount = tipAmountToSet;

    // The other fields can only be calculated if we have a valid Billed Amount
    // If the Billed Amount is 0, then the Tip Amount is the Total Amount
    if (billedAmount == 0.0) {
      totalAmount = tipAmount;
      tipPercentage = 100.0;

      totalAmountFieldController.text = totalAmount.toString();
      tipPercentageFieldController.text = tipPercentage.toString();
    } else if (billedAmount > 0.0) {
      totalAmount = billedAmount + tipAmount;
      tipPercentage = (tipAmount / billedAmount) * 100.0;

      totalAmountFieldController.text = totalAmount.toString();
      tipPercentageFieldController.text = tipPercentage.toString();
    }
  }
}
