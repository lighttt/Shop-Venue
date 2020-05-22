import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopvenue/models/product.dart';
import 'package:shopvenue/provider/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit_product_screen";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _isInit = true;
  bool _isLoading = false;

  var _editedProduct = Product(
    id: null,
    title: "",
    price: 0,
    description: "",
    imageURL: "",
  );

  var initValues = {
    'title': "",
    'price': "",
    'description': "",
    'imageURL': "",
  };

  @override
  void initState() {
    super.initState();
    _imageUrlController.addListener(_updateImageUrl);
  }

  // to update container when new image url is paste
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlFocusNode.dispose();
  }

  // save form and validate
  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    // loading occurs
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Error Occurred'),
                  content:
                      Text("Something has occurred! Product couldn't be added"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ));
      }
      //// after process finishes
       finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final String productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageURL': _editedProduct.imageURL,
        };
        _imageUrlController.text = _editedProduct.imageURL;
      }
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _editedProduct.id != null
            ? Text("Edit Product")
            : Text("Add Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: initValues['title'],
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'The title must not be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: value.trimLeft().trim(),
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          imageURL: _editedProduct.imageURL,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initValues['price'],
                      decoration: InputDecoration(labelText: "Price"),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'The price must not be empty';
                        }
                        if (double.tryParse(value) == null) {
                          return 'The price must be in a number format';
                        }
                        if (double.parse(value) <= 0) {
                          return "The price shouldnot be less than zero";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          imageURL: _editedProduct.imageURL,
                          price: double.parse(value),
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initValues['description'],
                      decoration: InputDecoration(labelText: "Description"),
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'The description must not be empty';
                        }
                        if (value.length < 10) {
                          return 'The description must be atleast 10 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: value.trim(),
                          id: _editedProduct.id,
                          imageURL: _editedProduct.imageURL,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 15, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: _imageUrlController.text.isEmpty
                              ? FittedBox(child: Text("Enter a image URL"))
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                            child: TextFormField(
                          decoration: InputDecoration(labelText: "Image URL"),
                          keyboardType: TextInputType.url,
                          focusNode: _imageUrlFocusNode,
                          controller: _imageUrlController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'The description must not be empty';
                            }
                            if (!value.startsWith("http") &&
                                !value.startsWith("https")) {
                              return 'The image url is not valid';
                            }
                            if (!value.endsWith(".png") &&
                                !value.endsWith(".jpg") &&
                                !value.endsWith(".jpeg") &&
                                !value.endsWith(".JPG")) {
                              return 'The image url is not correct';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              id: _editedProduct.id,
                              imageURL: value.trim(),
                              price: _editedProduct.price,
                            );
                          },
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
