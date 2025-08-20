package com.example.dummyapp;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    private static final String TAG = "DummyApp";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Handle the intent that started this activity
        handleIntent(getIntent());
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        // Handle new intents if the activity is already running
        handleIntent(intent);
    }

    private void handleIntent(Intent intent) {
        if (intent != null && Intent.ACTION_VIEW.equals(intent.getAction())) {
            Uri data = intent.getData();
            if (data != null && "weixin".equals(data.getScheme())) {
                // Log the received URI
                Log.d(TAG, "Received weixin URI: " + data.toString());

                // Display the URI in the UI
                TextView uriTextView = findViewById(R.id.uriTextView);
                if (uriTextView != null) {
                    uriTextView.setText("Received URI: " + data.toString());
                }

                // You can parse the URI components here if needed
                String host = data.getHost();
                String path = data.getPath();
                String query = data.getQuery();

                Log.d(TAG, "Host: " + host);
                Log.d(TAG, "Path: " + path);
                Log.d(TAG, "Query: " + query);
            }
        }
    }
}
