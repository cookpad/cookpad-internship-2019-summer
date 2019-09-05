package com.example.minicookpad

import com.bumptech.glide.Glide
import com.xwray.groupie.Item
import com.xwray.groupie.ViewHolder
import kotlinx.android.synthetic.main.item_recipe_image.view.*

class RecipeImageItem(
    val recipe: RecipeQuery.Recipe
) : Item<ViewHolder>() {
    override fun getLayout(): Int {
        return R.layout.item_recipe_image
    }

    override fun bind(viewHolder: ViewHolder, position: Int) {
        Glide.with(viewHolder.root.recipe_image)
            .load(recipe.media?.original)
            .into(viewHolder.root.recipe_image)
    }
}