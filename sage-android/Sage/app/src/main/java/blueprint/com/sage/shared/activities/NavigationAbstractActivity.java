package blueprint.com.sage.shared.activities;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
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
import blueprint.com.sage.shared.interfaces.NavigationInterface;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;
import blueprint.com.sage.utility.view.ViewUtils;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/4/15.
 * Activity that basically adds a nav bar to your activity;
 */
public class NavigationAbstractActivity extends AbstractActivity
                                        implements NavigationView.OnNavigationItemSelectedListener,
                                        NavigationInterface {

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
        initializeUser();
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
                mDrawerLayout.closeDrawers();
            }
        });

        mNavigationView.getMenu().clear();
        mNavigationView.inflateMenu(R.menu.menu_student);

        if (getUser().isAdmin())
            mNavigationView.inflateMenu(R.menu.menu_admin);

        mNavigationView.inflateMenu(R.menu.menu_logout);

        mEmail = ButterKnife.findById(mHeader, R.id.header_email);
        mName = ButterKnife.findById(mHeader, R.id.header_name);
        mPhoto = ButterKnife.findById(mHeader, R.id.header_photo);
    }

    public void initializeUser() {
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

    public void toggleDrawerUse(boolean useDrawer) {
        // Enable/Disable the icon being used by the drawer
        mToggle.setDrawerIndicatorEnabled(useDrawer);

        // Switch between the listeners as necessary
        if (useDrawer) {
            initializeDrawer();
        } else {
            showBack();
        }
    }

    public void showBack() {
        Drawable drawable = ContextCompat.getDrawable(this, R.drawable.abc_ic_ab_back_mtrl_am_alpha);

        mToolbar.setNavigationIcon(drawable);
        mToggle.setToolbarNavigationClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mDrawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED);
                onBackPressed();
            }
        });
    }

    @Override
    public void onBackPressed() {
        Fragment fragment = getSupportFragmentManager().findFragmentById(R.id.container);
        ViewUtils.hideKeyboard(fragment);
        if (mDrawerLayout.isDrawerOpen(mNavigationView)) mDrawerLayout.closeDrawers();
        else super.onBackPressed();
    }

    private void startCheckInActivity() {
        if (this instanceof CheckInActivity) return;
        startActivity(CheckInActivity.class);
    }

    private void startSchoolsActivity() {
        if (this instanceof BrowseActivity) return;
        startActivity(BrowseActivity.class);
    }

    private void startRequestsActivity() {
        if (this instanceof RequestsActivity) return;
        startActivity(RequestsActivity.class);
    }

    private void startActivity(Class<?> cls) {
        Intent intent = new Intent(this, cls);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK |
                Intent.FLAG_ACTIVITY_CLEAR_TASK |
                Intent.FLAG_ACTIVITY_NO_ANIMATION);

        startActivity(intent);

        overridePendingTransition(0, 0);
    }
}
