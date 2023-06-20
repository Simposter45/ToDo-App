import 'package:flutter/material.dart';
import 'package:todo_list/helper/get_categories.dart';
import 'package:todo_list/models/category_models.dart';

class Categories extends StatefulWidget {
  Categories({
    super.key,
  });

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<CategoryModel> categories = <CategoryModel>[];

  @override
  void initState() {
    super.initState();
    categories = getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Categories",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 22,
              // fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            // padding: EdgeInsets.symmetric(horizontal: 16),
            height: 150,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CategoryCard(
                      tasks: categories[index].tasks!,
                      categoryName: categories[index].categoryName!,
                      barLength: categories[index].barLength!),
                );
              },
            ),
          )
        ],
      ),
    ));
  }
}

class CategoryCard extends StatelessWidget {
  final double tasks;
  final String categoryName;
  final double barLength;

  const CategoryCard({
    super.key,
    required this.tasks,
    required this.categoryName,
    required this.barLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 180,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.deepPurple.shade500,
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(
                0,
                8,
              ),
              blurRadius: 10.0,
              // spreadRadius: 2.0,
            ), //BoxShadow
            BoxShadow(
              color: Colors.black38,
              offset: Offset(0, 0),
              blurRadius: 5,
              // spreadRadius: 1,
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text("${tasks} tasks"),
            const SizedBox(height: 10),
            Text(
              categoryName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Stack(
              children: [
                Container(
                  height: 5,
                  width: 140,
                  color: Colors.white,
                ),
                Container(
                  height: 5,
                  width: barLength, // Should be a Variable
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
