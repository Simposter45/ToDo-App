import 'package:todo_list/models/category_models.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> myCategories = <CategoryModel>[];
  CategoryModel categorieModel;

  //1
  categorieModel = new CategoryModel();
  categorieModel.tasks = 40;
  categorieModel.categoryName = "Business";
  categorieModel.barLength = 20;
  myCategories.add(categorieModel);

  //2
  categorieModel = new CategoryModel();
  categorieModel.tasks = 20;
  categorieModel.categoryName = "Hobbies";
  categorieModel.barLength = 30;
  myCategories.add(categorieModel);

  //3
  categorieModel = new CategoryModel();
  categorieModel.tasks = 60;
  categorieModel.categoryName = "Tech";
  categorieModel.barLength = 46;
  myCategories.add(categorieModel);

  //3
  categorieModel = new CategoryModel();
  categorieModel.tasks = 2;
  categorieModel.categoryName = "Theme";
  categorieModel.barLength = 67;
  myCategories.add(categorieModel);

  return myCategories;
}
