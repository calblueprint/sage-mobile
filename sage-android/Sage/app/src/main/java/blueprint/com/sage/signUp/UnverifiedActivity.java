package blueprint.com.sage.signUp;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

import blueprint.com.sage.R;

/**
 * Created by charlesx on 10/24/15.
 * Activity shown when a user isn't verified yet.
 */
public class UnverifiedActivity extends FragmentActivity {

    private SharedPreferences mPreferences;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mPreferences = getSharedPreferences(getString(R.string.preferences), MODE_PRIVATE);

    }
}
