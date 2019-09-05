package com.example.minicookpad

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import com.apollographql.apollo.ApolloCall
import com.apollographql.apollo.api.Response
import com.apollographql.apollo.exception.ApolloException
import com.xwray.groupie.GroupAdapter
import com.xwray.groupie.Item
import com.xwray.groupie.ViewHolder
import kotlinx.android.synthetic.main.fragment_recipe_detail.*

class RecipeDetailFragment : Fragment() {

    val recipeId: String?
        get() = arguments?.getString("recipe_id")

    val handler = Handler(Looper.getMainLooper())

    val adapter = GroupAdapter<ViewHolder>()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return layoutInflater.inflate(R.layout.fragment_recipe_detail, null, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        recipe_detail.adapter = adapter
        recipe_detail.layoutManager = LinearLayoutManager(requireContext())

        Log.d("recipeDetail", "recipeId $recipeId")
        apolloClient.query(RecipeQuery(recipeId!!)).enqueue(object : ApolloCall.Callback<RecipeQuery.Data>() {
            override fun onFailure(e: ApolloException) {
            }

            override fun onResponse(response: Response<RecipeQuery.Data>) {
                val recipe = response.data()?.recipe!!
                Log.d("recipeDetail", "recipe $recipe")

                handler.post {
                    renderRecipe(recipe)
                }
            }
        })
    }

    fun renderRecipe(recipe: RecipeQuery.Recipe) {
        val items = mutableListOf<Item<ViewHolder>>()

        items.add(RecipeImageItem(recipe))
        items.add(RecipeNameItem(recipe))
        items.add(RecipeDescriptionItem(recipe))
        val ingredients = recipe.ingredients.orEmpty().map { ingredient ->
            RecipeIngredientItem(ingredient)
        }
        items.addAll(ingredients)

        adapter.update(items)
    }
}

