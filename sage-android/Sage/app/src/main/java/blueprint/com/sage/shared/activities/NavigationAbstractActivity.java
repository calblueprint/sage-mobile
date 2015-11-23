package blueprint.com.sage.shared.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import blueprint.com.sage.R;
import blueprint.com.sage.browse.BrowseActivity;
import blueprint.com.sage.browse.fragments.UserFragment;
import blueprint.com.sage.checkIn.CheckInActivity;
import blueprint.com.sage.requests.RequestsActivity;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/4/15.
 * Activity that basically adds a nav bar to your activity;
 */
public class NavigationAbstractActivity extends AbstractActivity
                                        implements NavigationView.OnNavigationItemSelectedListener {

    @Bind(R.id.drawer_layout) DrawerLayout mDrawerLayout;
    @Bind(R.id.left_drawer) NavigationView mNavigationView;
    @Bind(R.id.toolbar) Toolbar mToolbar;

    View mHeader;
    TextView mEmail;
    TextView mName;
    CircleImageView mPhoto;

    private ActionBarDrawerToggle mToggle;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_navigation);
        ButterKnife.bind(this);

        setSupportActionBar(mToolbar);
        initializeDrawer();
        initializeViews();
    }

    private void initializeDrawer() {
        mToggle =
                new ActionBarDrawerToggle(this, mDrawerLayout, mToolbar, R.string.open, R.string.close) {
                    @Override
                    public void onDrawerClosed(View drawerView) {
                        super.onDrawerClosed(drawerView);
                    }

                    @Override
                    public void onDrawerOpened(View drawerView) {
                        super.onDrawerOpened(drawerView);
                    }
                };
        mNavigationView.setNavigationItemSelectedListener(this);
        mDrawerLayout.setDrawerListener(mToggle);
        mToggle.syncState();
    }

    private void initializeViews() {
        mHeader = mNavigationView.inflateHeaderView(R.layout.navigation_header);
        mHeader.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                FragUtils.replaceBackStack(R.id.container,
                        UserFragment.newInstance(getUser()),
                        NavigationAbstractActivity.this);
            }
        });

        mEmail = ButterKnife.findById(mHeader, R.id.header_email);
        mName = ButterKnife.findById(mHeader, R.id.header_name);
        mPhoto = ButterKnife.findById(mHeader, R.id.header_photo);

        mEmail.setText(getUser().getEmail());
        mName.setText(getUser().getName());
        getUser().loadUserImage(this, mPhoto);
    }

    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.check_in:
                startCheckInActivity();
            case R.id.announcements:
                Log.e("Selected announcements", "yay");
                break;
            case R.id.log_out:
                Log.e("Logging out", "yay");
                NetworkUtils.logoutCurrentUser(this);
                break;
            case R.id.schools:
                startSchoolsActivity();
                break;
            case R.id.requests:
                startRequestsActivity();
                break;
        }

        mDrawerLayout.closeDrawers();
        return true;
    }

    private void startCheckInActivity() {
        if (this instanceof CheckInActivity) return;

        Intent intent = new Intent(this, CheckInActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }

    private void startSchoolsActivity() {
        if (this instanceof BrowseActivity) return;

        Intent intent = new Intent(this, BrowseActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }

    private void startRequestsActivity() {
        if (this instanceof RequestsActivity) return;

        Intent intent = new Intent(this, RequestsActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }
}
