package com.example.minicookpad

import com.xwray.groupie.Item
import com.xwray.groupie.ViewHolder
import kotlinx.android.synthetic.main.item_recipe_ingredient.view.*

class RecipeIngredientItem(
    val ingredient: RecipeQuery.Ingredient
) : Item<ViewHolder>() {
    override fun getLayout(): Int {
        return R.layout.item_recipe_ingredient
    }

    override fun bind(viewHolder: ViewHolder, position: Int) {
        viewHolder.root.recipe_ingredient_name.text = ingredient.name
        viewHolder.root.recipe_ingredient_quantity.text = ingredient.quantity
    }
}