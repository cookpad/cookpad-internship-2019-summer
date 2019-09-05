package com.example.minicookpad

import android.content.Intent
import com.xwray.groupie.Item
import com.xwray.groupie.ViewHolder
import kotlinx.android.synthetic.main.item_recipe_description.view.*

class RecipeDescriptionItem(
    val recipe: RecipeQuery.Recipe
) : Item<ViewHolder>() {
    override fun getLayout(): Int {
        return R.layout.item_recipe_description
    }

    override fun bind(viewHolder: ViewHolder, position: Int) {
        viewHolder.root.setOnClickListener {
            val intent = Intent().apply {
                action = Intent.ACTION_SEND
                putExtra(Intent.EXTRA_TEXT, "共有したい文字列")
                type = "text/plain"
            }
            viewHolder.root.context.startActivity(intent)
        }

        viewHolder.root.recipe_description.text = recipe.description

    }
}