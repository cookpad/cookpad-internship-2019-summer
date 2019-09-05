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
import com.xwray.groupie.ViewHolder
import kotlinx.android.synthetic.main.fragment_recipe_list.*

class RecipeListFragment : Fragment() {

    val handler = Handler(Looper.getMainLooper())

    val adapter = GroupAdapter<ViewHolder>()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_recipe_list, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)


        recipe_list.adapter = adapter
        recipe_list.layoutManager = LinearLayoutManager(requireContext())

        apolloClient.query(RecipesQuery()).enqueue(object : ApolloCall.Callback<RecipesQuery.Data>() {
            override fun onFailure(e: ApolloException) {
            }

            override fun onResponse(response: Response<RecipesQuery.Data>) {
                val recipes = response.data()?.recipes ?: emptyList()
                Log.d("apollo", "recipes $recipes")

                handler.post {
                    renderRecipes(recipes)
                }
            }
        })
    }

    fun renderRecipes(recipes: List<RecipesQuery.Recipe>) {
        val items = recipes.map {recipe ->
            RecipeListItem(recipe)
        }

        adapter.addAll(items)
    }
}