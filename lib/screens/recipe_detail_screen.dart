import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '/providers/recipes.dart';
import 'editor_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key});

  static const routeName = '/recipe-detail';

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final recipeId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedRecipe = Provider.of<Recipes>(context).findById(recipeId);
    return Scaffold(
      body: SlidingUpPanel(
        parallaxEnabled: true,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minHeight: (media.size.height / 1.6),
        maxHeight: media.size.height,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        panel: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Text(
                loadedRecipe.title,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(EditorScreen.routeName,
                          arguments: {'type': 'id', 'data': loadedRecipe.id!});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc71565),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: media.size.width * 0.1),
                      child: const Column(
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 30),
                          SizedBox(height: 5),
                          Text(
                            "Edit",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await Provider.of<Recipes>(context, listen: false)
                            .deleteRecipe(loadedRecipe.id.toString())
                            .then((value) => Navigator.of(context).pop());
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Deleting failed!',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc71565),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: media.size.width * 0.1),
                      child: const Column(
                        children: [
                          Icon(Icons.delete_forever,
                              color: Colors.white, size: 30),
                          SizedBox(height: 5),
                          Text(
                            "Delete",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ReadMoreText(
                  loadedRecipe.description,
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                  colorClickableText: Colors.blue,
                  trimLines: 5,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: ' Show More',
                  trimExpandedText: ' Show Less',
                  moreStyle:
                      const TextStyle(color: Colors.black54, fontSize: 15),
                  lessStyle:
                      const TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Hero(
                      tag: recipeId,
                      child: ClipRRect(
                        child: loadedRecipe.image == ''
                            ? Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                loadedRecipe.image,
                                fit: BoxFit.cover,
                              ),
                      ))
                ],
              ),
              Positioned(
                top: 40,
                left: 20,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(
                    backgroundColor: Color(0xffc71565),
                    radius: 25,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
