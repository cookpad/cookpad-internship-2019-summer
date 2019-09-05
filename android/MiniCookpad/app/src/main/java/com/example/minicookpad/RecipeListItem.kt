package com.example.minicookpad

import androidx.core.os.bundleOf
import androidx.navigation.findNavController
import com.bumptech.glide.Glide
import com.xwray.groupie.Item
import com.xwray.groupie.ViewHolder
import kotlinx.android.synthetic.main.item_recipe_list.view.*

class RecipeListItem(
    val recipe: RecipesQuery.Recipe
) : Item<ViewHolder>() {
    override fun getLayout(): Int {
        return R.layout.item_recipe_list
    }

    override fun bind(viewHolder: ViewHolder, position: Int) {
        viewHolder.root.setOnClickListener {
            val arguments = bundleOf(
                "recipe_id" to recipe.id
            )

            viewHolder.root.findNavController()
                .navigate(R.id.action_recipeListFragment_to_recipeDetailFragment, arguments)
        }

        viewHolder.root.recipe_name.text = recipe.name
        viewHolder.root.recipe_description.text = recipe.description
        Glide.with(viewHolder.root.recipe_image)
            .load(recipe.media?.thumbnail)
            .into(viewHolder.root.recipe_image)
    }
}