import 'package:flutter/material.dart';

// Main App
void main() => runApp(new App());

// App Name
String appName = "YET ANOTHER TIP CALCULATOR";

// Text Resources
String billedAmountString = "BILLED AMOUNT";
String tipPercentageString = "TIP (0-100\%)";
String totalAmountString = "TOTAL AMOUNT";
String tipAmountString = "TIP AMOUNT";
String splitTipString = "SPLIT BILL";
String splitBillByString = "SPLIT BILL BY";
String splitTotalAmountString = "TOTAL PER SPLIT";
String splitTipAmountString = "TIP PER SPLIT";
String resetString = "RESET";

String defaultTipPercentageString = "15";
String defaultSplitByString = "1";

String invalidBilledAmountString = "INVALID BILLED AMOUNT!";
String invalidTipPercentageString = "INVALID TIP PERCENTAGE!";
String invalidTotalAmountString = "INVALID TOTAL AMOUNT!";
String invalidTipTotalString = "INVALID TIP TOTAL! ";
String invalidSplitBillByString = "INVALID SPLIT!";
String invalidSplitTotalAmountString = "INVALID SPLIT TOTAL!";
String invalidSplitTipAmountString = "INVALID SPLIT TIP!";

String billAmountLessThanZeroString = "BILL AMOUNT < 0.0 !";

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

  // App Title
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
          centerTitle: true,
          // This removes the blurred bottom-line of the AppBar
          elevation: 1.0,
          textTheme: new TextTheme(
              title: new TextStyle(
                  color: const Color(0xFF000000),
                  textBaseline: TextBaseline.ideographic,
                  fontFamily: 'Mina',
                  letterSpacing: 4.0,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.white,
        body: new Column(
          // Column's children consist two rows, one for the inputs & one for the reset button.
          children: <Widget>[
            new Flexible(
                flex: 2,
                child: new InputFieldWidget(calcFields: calcFields)),
            new Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: new SplitByWidget(calcFields: calcFields)),
            new Flexible(
                flex: 1,
                child: new SplitInputFieldWidget(calcFields: calcFields)),
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

// Widget that holds the main input fields
class InputFieldWidget extends StatefulWidget {
  InputFieldWidget({Key key, this.calcFields}) : super(key: key);

  // Reference to the to the calculator fields instance
  final CalculatorFields calcFields;

  // Create InputWidget's state
  @override
  _InputFieldWidgetState createState() =>
      new _InputFieldWidgetState(calcFields);
}

// Widget that holds the 'Split By' fields
class SplitByWidget extends StatefulWidget {
  SplitByWidget({Key key, this.calcFields}) : super(key: key);

  // Reference to the to the calculator fields instance
  final CalculatorFields calcFields;

  // Create SplitByWidget's state
  @override
  _SplitByWidgetState createState() => new _SplitByWidgetState(calcFields);
}

// Widget that holds all the split input fields
class SplitInputFieldWidget extends StatefulWidget {
  SplitInputFieldWidget({Key key, this.calcFields}) : super(key: key);

  // Reference to the to the calculator fields instance
  final CalculatorFields calcFields;

  // Create SplitInputWidget's state
  @override
  _SplitInputFieldWidgetState createState() =>
      new _SplitInputFieldWidgetState(calcFields);
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
          padding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 175.0),
          child: new Text(resetString,
              textAlign: TextAlign.center,
              style: new TextStyle(
                  textBaseline: TextBaseline.ideographic,
                  fontFamily: 'Mina',
                  letterSpacing: 10.0,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
          onPressed: () {
            // Reset to default
            calcFields.resetToDefault();
          }),
    );
  }
}

// Holds the content & state of the main input fields
class _InputFieldWidgetState extends State<InputFieldWidget> {
  _InputFieldWidgetState(this.calcFields);

  // Reference to the to the calculator fields instance
  CalculatorFields calcFields;

  // Input TextFields
  TextField billedAmountField;
  TextField tipPercentageField;
  TextField totalAmountTextField;
  TextField tipAmountTextField;

  // Input Field Text Style
  TextStyle labelTextStyle = new TextStyle(
      textBaseline: TextBaseline.ideographic,
      fontFamily: 'Mina',
      letterSpacing: 2.0,
      fontSize: 12.0);

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
      crossAxisSpacing: 50.0,
      crossAxisCount: 2,
      children: <Widget>[
        billedAmountField = new TextField(
            controller: calcFields.billAmountFieldController,
            autocorrect: false,
            autofocus: true,
            maxLines: 1,
            decoration: new InputDecoration(
                labelText: billedAmountString, labelStyle: labelTextStyle),
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
                labelStyle: labelTextStyle),
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
                labelText: totalAmountString, labelStyle: labelTextStyle),
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
              labelText: tipAmountString, labelStyle: labelTextStyle),
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
        new SnackBar(content: new Text(snackBarString, style: labelTextStyle)));

    // Reset calculated amounts (Reset tip if invalid)
    calcFields.resetExceptTipPercentage();
  }

  // Handle Invalid Tip Percentage
  invalidTipPercentage() {
    // Invalid Tip Percentage Snackbar notification
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(invalidTipPercentageString, style: labelTextStyle)));

    // Reset calculated amounts
    calcFields.resetCalculatedFields();
  }

  // Handle Invalid Total Amount
  invalidTotalAmount() {
    // Invalid Total Amount Snackbar notification
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(invalidTotalAmountString, style: labelTextStyle)));

    // Reset calculated amounts
    calcFields.resetExceptBilledAmount();
  }

  // Handle Invalid Tip Amount
  invalidTipAmount() {
    // Invalid Tip Amount Snackbar notification
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(invalidTipTotalString, style: labelTextStyle)));

    // Reset calculated amounts
    calcFields.resetCalculatedFields();
  }
}

// Holds the content & state of the main input fields
class _SplitByWidgetState extends State<SplitByWidget> {
  _SplitByWidgetState(this.calcFields);

  // Reference to the to the calculator fields instance
  CalculatorFields calcFields;

  // Input TextFields
  TextField splitBillTextField;

  // Input Field Text Style
  TextStyle labelTextStyle = new TextStyle(
      textBaseline: TextBaseline.ideographic,
      fontFamily: 'Mina',
      letterSpacing: 2.0,
      fontSize: 12.0);

  // Method is re-run every time setState is called
  @override
  Widget build(BuildContext context) {
    // Set the default tip percentage on build
    calcFields.splitBillFieldController.text = defaultSplitByString;

    // 1x1 GridView of the Input
    return new GridView.count(
      primary: true,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      shrinkWrap: true,
      //controller: new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true),
      childAspectRatio: 2.0,
      mainAxisSpacing: 20.0,
      crossAxisSpacing: 50.0,
      crossAxisCount: 1,
      children: <Widget>[
        splitBillTextField = new TextField(
          controller: calcFields.splitBillFieldController,
          autocorrect: false,
          maxLines: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: new InputDecoration(
              labelText: splitBillByString,
              labelStyle: labelTextStyle,
              hintText: defaultSplitByString),
          onChanged: (String value) {
            try {
              if (int.parse(value) >= 0.0) {
                calcFields.setSplitBillBy(int.parse(value));
              } else {
                invalidSplitBy();
              }
            } catch (exception) {
              invalidSplitBy();
            }
          },
        )
      ],
    );
  }

  // Handle Invalid Split Number
  invalidSplitBy() {
    // Invalid Split By Snackbar notification
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(invalidSplitBillByString, style: labelTextStyle)));

    // Reset split calculated amounts
    calcFields.resetSplitCalculatedFields();
  }
}

// Holds the content & state of the input fields
class _SplitInputFieldWidgetState extends State<SplitInputFieldWidget> {
  _SplitInputFieldWidgetState(this.calcFields);

  // Reference to the to the calculator fields instance
  CalculatorFields calcFields;

  // Input TextFields
  TextField splitTotalAmountTextField;
  TextField splitTipAmountTextField;

  // Input Field Text Style
  TextStyle labelTextStyle = new TextStyle(
      textBaseline: TextBaseline.ideographic,
      fontFamily: 'Mina',
      letterSpacing: 2.0,
      fontSize: 12.0);

  // Method is re-run every time setState is called
  @override
  Widget build(BuildContext context) {
    // 2x2 GridView of the Inputs
    return new GridView.count(
      primary: true,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      shrinkWrap: true,
      childAspectRatio: 2.0,
      mainAxisSpacing: 20.0,
      crossAxisSpacing: 50.0,
      crossAxisCount: 2,
      children: <Widget>[
        splitTotalAmountTextField = new TextField(
          controller: calcFields.splitTotalAmountFieldController,
          autocorrect: false,
          maxLines: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: new InputDecoration(
              labelText: splitTotalAmountString, labelStyle: labelTextStyle),
          onChanged: (String value) {
            try {
              if (double.parse(value) >= 0.0) {
                calcFields.setSplitTotalAmount(double.parse(value));
              } else {
                invalidSplitTotalAmount();
              }
            } catch (exception) {
              invalidSplitTotalAmount();
            }
          },
        ),
        splitTipAmountTextField = new TextField(
          controller: calcFields.splitTipAmountFieldController,
          autocorrect: false,
          maxLines: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: new InputDecoration(
              labelText: splitTipAmountString, labelStyle: labelTextStyle),
          onChanged: (String value) {
            try {
              if (double.parse(value) >= 0.0) {
                calcFields.setSplitTipAmount(double.parse(value));
              } else {
                invalidSplitTipAmount();
              }
            } catch (exception) {
              invalidSplitTipAmount();
            }
          },
        )
      ],
    );
  }

  // Handle Invalid Split Total Amount
  invalidSplitTotalAmount() {
    // Invalid Split Total Snackbar notification
    Scaffold.of(context).showSnackBar(new SnackBar(
        content:
            new Text(invalidSplitTotalAmountString, style: labelTextStyle)));

    // Reset calculated amounts
    calcFields.resetCalculatedFieldsExceptSplitTotal();
  }

  // Handle Invalid Split Tip Amount
  invalidSplitTipAmount() {
    // Invalid Split Tip Amount Snackbar notification
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(invalidSplitTipAmountString, style: labelTextStyle)));

    // Reset calculated amounts
    calcFields.resetCalculatedFields();
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
  double splitTotalAmount = 0.0;
  double splitTipAmount = 0.0;

  int splitByNumber = 1;

  // Text Editing Controllers
  TextEditingController billAmountFieldController;
  TextEditingController tipPercentageFieldController;
  TextEditingController totalAmountFieldController;
  TextEditingController tipAmountFieldController;
  TextEditingController splitBillFieldController;
  TextEditingController splitTotalAmountFieldController;
  TextEditingController splitTipAmountFieldController;

  // Constructor to initialize controllers & set defaults
  CalculatorFields() {
    tipPercentage = 15.0;

    billAmountFieldController = new TextEditingController();
    tipPercentageFieldController = new TextEditingController();
    totalAmountFieldController = new TextEditingController();
    tipAmountFieldController = new TextEditingController();
    splitBillFieldController = new TextEditingController();
    splitTotalAmountFieldController = new TextEditingController();
    splitTipAmountFieldController = new TextEditingController();
  }

  // Set Controller Tesxt from Values.
  // Clear Controller if the Value is 0.0
  // Don't update the Controller if the Value is the same (Avoids unnecessary decimal addition)
  setControllerText() {
    if(billedAmount == 0.0) {
      billAmountFieldController.clear();
    } else if(billedAmount.toString() == billAmountFieldController.text) {
      billAmountFieldController.text = billedAmount.toString();
    }

    if(tipAmount == 0.0) {
      tipAmountFieldController.clear();
    } else if(tipAmount.toString() == tipAmountFieldController.text) {
      tipAmountFieldController.text = tipAmount.toString();
    }

    if(totalAmount == 0.0) {
      totalAmountFieldController.clear();
    } else if(totalAmount.toString() == totalAmountFieldController.text) {
      totalAmountFieldController.text = totalAmount.toString();
    }

    if(tipPercentage == 0.0) {
      tipPercentageFieldController.clear();
    } else if(tipPercentage.toString() == tipPercentageFieldController.text) {
      tipPercentageFieldController.text = tipPercentage.toString();
    }

    if(splitTotalAmount == 0.0) {
      splitTotalAmountFieldController.clear();
    } else if(splitTotalAmount.toString() == splitTotalAmountFieldController.text) {
      splitTotalAmountFieldController.text = splitTotalAmount.toString();
    }

    if(splitTipAmount == 0.0) {
      splitTipAmountFieldController.clear();
    } else if(splitTipAmount.toString() == splitTipAmountFieldController.text) {
      splitTipAmountFieldController.text = splitTipAmount.toString();
    }
  }

  resetControllerText() {
    billAmountFieldController.clear();
    tipAmountFieldController.clear();
    totalAmountFieldController.clear();
    tipPercentageFieldController.text = defaultTipPercentageString;
    splitBillFieldController.text = defaultSplitByString;
    splitTotalAmountFieldController.clear();
    splitTipAmountFieldController.clear();
  }

  // Reset all input field values to their defaults
  resetToDefault() {
    billedAmount = 0.0;
    totalAmount = 0.0;
    tipAmount = 0.0;
    tipPercentage = 15.0;
    splitTotalAmount = 0.0;
    splitTipAmount = 0.0;

    splitByNumber = 1;

    resetControllerText();
  }


  // Reset all input field values to their defaults.
  // Reset the tip percentage only if it is invalid.
  resetExceptTipPercentage() {
    tipAmount = 0.0;
    totalAmount = 0.0;
    billedAmount = 0.0;
    splitTipAmount = 0.0;
    splitTotalAmount = 0.0;

    tipAmountFieldController.clear();
    billAmountFieldController.clear();
    totalAmountFieldController.clear();
    splitTipAmountFieldController.clear();
    splitTotalAmountFieldController.clear();
    splitBillFieldController.text = defaultSplitByString;

    if (tipPercentage < 0.0 || tipPercentage > 100.0) {
      tipPercentage = 15.0;
      tipPercentageFieldController.text = defaultTipPercentageString;
    }
  }

  // Reset only the calculated & split (Tip Amount & Total Amount) to defaults.
  resetCalculatedFields() {
    // Assume the tip to be 0
    tipAmount = 0.0;
    splitTipAmount = 0.0;
    tipPercentage = 0.0;

    tipPercentageFieldController.clear();
    tipAmountFieldController.clear();
    splitTipAmountFieldController.clear();

    // Assume the bill to be the total.
    totalAmount = billedAmount;
    totalAmountFieldController.text = totalAmount.toString();

    if(splitByNumber > 0) {
      splitTotalAmount = billedAmount / splitByNumber;
      splitTotalAmountFieldController.text = splitTotalAmount.toString();
    } else {
      splitTotalAmount = 0.0;
      splitTotalAmountFieldController.clear();
    }
  }

  // Reset only the calculated & split (Tip Amount & Total Amount) to defaults.
  resetCalculatedFieldsExceptSplitTotal() {
    // Assume the tip to be 0
    tipAmount = 0.0;
    splitTipAmount = 0.0;
    tipPercentage = 0.0;

    tipPercentageFieldController.clear();
    tipAmountFieldController.clear();
    splitTipAmountFieldController.clear();

    // Assume the bill to be the total.
    totalAmount = billedAmount;
    totalAmountFieldController.text = totalAmount.toString();
  }

  // Reset all except the Billed Amount
  resetExceptBilledAmount() {
    tipPercentage = 0.0;
    totalAmount = 0.0;
    tipAmount = 0.0;
    splitByNumber = 1;
    splitTotalAmount = 0.0;
    splitTipAmount = 0.0;

    setControllerText();
  }

  // Reset split calculated fields
  resetSplitCalculatedFields() {
    splitTipAmount = 0.0;
    splitTotalAmount = 0.0;

    splitTipAmountFieldController.clear();
    splitTotalAmountFieldController.clear();
  }

  // Set the calculated (Tip Amount & Total Amount) amounts.
  // The field values are expected to already be set.
  setCalculatedAmountsToController() {
    tipAmountFieldController.text = tipAmount.toString();
    totalAmountFieldController.text = totalAmount.toString();

    splitTipAmountFieldController.text = splitTipAmount.toString();
    splitTotalAmountFieldController.text = splitTotalAmount.toString();
  }

  // Set the calculated (Tip Amount & Total Amount) amounts.
  // The field values are expected to already be set.
  setTipValuesToController() {
    tipAmountFieldController.text = tipAmount.toString();
    tipPercentageFieldController.text = tipPercentage.toString();

    splitTipAmountFieldController.text = splitTipAmount.toString();
    splitTotalAmountFieldController.text = splitTotalAmount.toString();
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

      if (splitByNumber > 0) {
        splitTotalAmount = totalAmount / splitByNumber;
        splitTipAmount = tipAmount / splitByNumber;
      }

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

      if (splitByNumber > 0) {
        splitTotalAmount = totalAmount / splitByNumber;
        splitTipAmount = tipAmount / splitByNumber;
      }

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

    // Handle split amounts if applicable
    if(splitByNumber > 0) {
      splitTipAmount = tipAmount / splitByNumber;
      splitTotalAmount = totalAmount / splitByNumber;
    } else {
      splitTipAmount = 0.0;
      splitTotalAmount = 0.0;
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
    } else if (billedAmount > 0.0) {
      totalAmount = billedAmount + tipAmount;
      tipPercentage = (tipAmount / billedAmount) * 100.0;
    }

    // Handle split amounts if applicable
    if(splitByNumber > 0) {
      splitTipAmount = tipAmount / splitByNumber;
      splitTotalAmount = totalAmount / splitByNumber;
    } else {
      splitTipAmount = 0.0;
      splitTotalAmount = 0.0;
    }

    tipPercentageFieldController.text = tipPercentage.toString();
    totalAmountFieldController.text = totalAmount.toString();
    splitTipAmountFieldController.text = splitTipAmount.toString();
    splitTotalAmountFieldController.text = splitTotalAmount.toString();
  }

  // Set the user-input 'Split By' number & attempt to calculate the other fields.
  setSplitBillBy(int splitByNumberToSet) {
    splitByNumber = splitByNumberToSet;

    // Split Tip & Total can only be calculated with a valid Split Number
    if (splitByNumber > 0) {
      // Split Total can only be calculated with a valid Total
      if (totalAmount > 0) {
        splitTotalAmount = totalAmount / splitByNumber;
        splitTotalAmountFieldController.text = splitTotalAmount.toString();
      }

      // Split Tip can only be calculated with a valid Tip
      if (tipAmount > 0) {
        splitTipAmount = tipAmount / splitByNumber;
        splitTipAmountFieldController.text = splitTipAmount.toString();
      }
    } else {
      // Clear Split Tip & Totals if the Split Number is invalid
      splitTotalAmountFieldController.clear();
      splitTipAmountFieldController.clear();
    }
  }

  // Set the user-input 'Split Total' & attempt to calculate the other fields
  setSplitTotalAmount(double splitTotalAmountToSet) {
    splitTotalAmount = splitTotalAmountToSet;

    // Upstream calculations can only be done if the Split Number is valid
    if(splitByNumber > 0) {
      // If the Billed Amount is 0 or lesser than 0, the entire Total Amount is the Tip Amount
      // Otherwise the Tip Amount is the net between the Total & Billed Amount
      if (billedAmount <= 0.0) {
        tipPercentage = 100.0;
        totalAmount = splitTotalAmount*splitByNumber;
        tipAmount = totalAmount;
        splitTipAmount = tipAmount/splitByNumber;
      } else {
        totalAmount = splitTotalAmount*splitByNumber;
        tipAmount = totalAmount - billedAmount;
        tipPercentage = (tipAmount / billedAmount) * 100.0;
        splitTipAmount = tipAmount/splitByNumber;
      }

      tipPercentageFieldController.text = tipPercentage.toString();
      tipAmountFieldController.text = tipAmount.toString();
      totalAmountFieldController.text = totalAmount.toString();
      splitTipAmountFieldController.text = splitTipAmount.toString();
    } else {
      // Clear Split Tip if the Split Number is invalid
      splitTotalAmountFieldController.clear();
    }
  }

  // Set the user-input 'Split Tip' & attempt to calculate the other fields
  setSplitTipAmount(double splitTipAmountToSet) {
    splitTipAmount = splitTipAmountToSet;

    // Upstream calculations can only be done if the Split Number is valid
    if(splitByNumber > 0) {
      // The other fields can only be calculated if we have a valid Billed Amount
      // If the Billed Amount is 0, then the Tip Amount is the Total Amount
      if (billedAmount == 0.0) {
        tipPercentage = 100.0;
        tipAmount = splitTipAmount*splitByNumber;
        totalAmount = tipAmount;
        splitTotalAmount = totalAmount/splitByNumber;
      } else if (billedAmount > 0.0) {
        tipAmount = splitTipAmount*splitByNumber;
        totalAmount = billedAmount + tipAmount;
        splitTotalAmount = totalAmount/splitByNumber;
        tipPercentage = (tipAmount / billedAmount) * 100.0;
      }

      tipPercentageFieldController.text = tipPercentage.toString();
      tipAmountFieldController.text = tipAmount.toString();
      totalAmountFieldController.text = totalAmount.toString();
      splitTotalAmountFieldController.text = splitTotalAmount.toString();
    } else {
      // Clear Split Total if the Split Number is invalid
      splitTipAmountFieldController.clear();
    }
  }
}
