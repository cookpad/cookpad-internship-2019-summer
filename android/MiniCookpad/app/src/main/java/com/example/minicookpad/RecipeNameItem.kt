package com.example.minicookpad

import com.xwray.groupie.Item
import com.xwray.groupie.ViewHolder
import kotlinx.android.synthetic.main.item_recipe_name.view.*

class RecipeNameItem(
    val recipe: RecipeQuery.Recipe
) : Item<ViewHolder>() {
    override fun getLayout(): Int {
        return R.layout.item_recipe_name
    }

    override fun bind(viewHolder: ViewHolder, position: Int) {
        viewHolder.root.recipe_name.text = recipe.name
    }
}
