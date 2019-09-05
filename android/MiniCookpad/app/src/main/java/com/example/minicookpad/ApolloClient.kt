package com.example.minicookpad

import com.apollographql.apollo.ApolloClient
import okhttp3.FormBody
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONObject

private const val authoCenterEndpoint = "<autho endpoint>"
private const val dankaiEndpoint = "<dankai endpoint>"

private val authoCenterClient = OkHttpClient()

fun getToken(): String {
    val userId = "<userId>"
    val password = "<password>"

    val tokenRequest = Request.Builder()
        .url(authoCenterEndpoint)
        .post(
            FormBody.Builder()
                .add("grant_type", "big_fake_password")
                .add("user_id", userId)
                .add("password", password)
                .build()
        )
        .build()
    val tokenResponse = authoCenterClient.newCall(tokenRequest).execute()

    return if (tokenResponse.isSuccessful) {
        val json = JSONObject(tokenResponse.body()?.string())
        json["id_token"].toString()
    } else {
        ""
    }
}

val apolloClient: ApolloClient = ApolloClient.builder()
    .serverUrl(dankaiEndpoint)
    .okHttpClient(
        OkHttpClient.Builder()
            .addInterceptor { chain -> // headerにID Tokenを載せます
                val newRequest = chain.request().newBuilder()
                    .addHeader("Authorization", "Bearer ${getToken()}")
                    .build()
                chain.proceed(newRequest)
            }
            .build()
    )
    .build()