package blueprint.com.sage.shared.adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by charlesx on 10/12/15.
 */
public class SimplePagerAdapter extends FragmentPagerAdapter {
    private List<Fragment> mFragments;
    private List<String> mTitles;

    public SimplePagerAdapter(FragmentManager fm) {
        super(fm);
        mFragments = new ArrayList<>();
        mTitles = new ArrayList<>();
    }

    @Override
    public Fragment getItem(int position) {
        Log.e("asdf", "" + getCount());
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
