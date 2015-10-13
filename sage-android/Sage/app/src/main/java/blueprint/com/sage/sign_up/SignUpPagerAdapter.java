package blueprint.com.sage.sign_up;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by charlesx on 10/12/15.
 */
public class SignUpPagerAdapter extends FragmentPagerAdapter {
    private List<Fragment> mFragments;
    private List<String> mTitles;

    public SignUpPagerAdapter(FragmentManager fm) {
        super(fm);
        mFragments = new ArrayList<>();
        mTitles = new ArrayList<>();
    }

    @Override
    public Fragment getItem(int position) {
        return mFragments.get(position);
    }

    @Override
    public int getCount() { return mFragments.size(); }

    @Override
    public CharSequence getPageTitle(int position) { return mTitles.get(position); }

    public void addFragment(Fragment fragment, String title) {
        mFragments.add(fragment);
        mTitles.add(title);
    }
}
