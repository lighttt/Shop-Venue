import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopvenue/provider/products_provider.dart';
import 'package:shopvenue/screens/product_details_screen.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchItems =
        Provider.of<Products>(context, listen: false).getSearchItems(query);
    return ListView.builder(
      itemBuilder: (ctx, index) => Column(
        children: <Widget>[
          ListTile(
            title: Text(searchItems[index].title),
            onTap: () {
              Navigator.pushNamed(context, ProductDetailsScreen.routeName,
                  arguments: searchItems[index].id);
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(searchItems[index].imageURL),
            ),
          ),
          Divider()
        ],
      ),
      itemCount: searchItems.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchItems = Provider.of<Products>(context).getSearchItems(query);
    return query.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Center(child: Text('Search product items'))],
          )
        : ListView.builder(
            itemBuilder: (ctx, index) => Column(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, ProductDetailsScreen.routeName,
                        arguments: searchItems[index].id);
                  },
                  title: Text(searchItems[index].title),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(searchItems[index].imageURL),
                  ),
                ),
                Divider()
              ],
            ),
            itemCount: searchItems.length,
          );
  }
}
