package blueprint.com.sage.shared.activities;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.Toolbar;
import android.view.View;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.interfaces.ToolbarInterface;
import blueprint.com.sage.utility.view.ViewUtils;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/4/15.
 * Activity that basically adds a nav bar to your activity;
 */
public class BackAbstractActivity extends AbstractActivity implements ToolbarInterface {

    @Bind(R.id.toolbar) Toolbar mToolbar;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_back);
        ButterKnife.bind(this);

        initializeToolbar(mToolbar);
    }

    private void initializeToolbar(Toolbar toolbar) {
        setSupportActionBar(toolbar);

        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
        }

        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });
    }

    @Override
    public void onBackPressed() {
        Fragment fragment = getSupportFragmentManager().findFragmentById(R.id.container);
        ViewUtils.hideKeyboard(fragment);
        super.onBackPressed();
    }

    @Override
    public void setToolbarElevation(float elevation) {
        ViewUtils.setElevation(mToolbar, elevation);
    }

    @Override
    public void showToolbar(Toolbar toolbar) {
        mToolbar.setVisibility(View.GONE);
        initializeToolbar(toolbar);
    }

    @Override
    public void hideToolbar(Toolbar toolbar) {
        mToolbar.setVisibility(View.VISIBLE);
        initializeToolbar(mToolbar);
    }

    @Override
    public void setTitle(int resId) {
        setTitle(getString(resId));
    }

    @Override
    public void setTitle(String string) {
        if (getSupportActionBar() != null) {
            getSupportActionBar().setTitle(string);
        }
    }
}
