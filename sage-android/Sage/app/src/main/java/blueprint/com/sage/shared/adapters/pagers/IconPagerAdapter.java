package blueprint.com.sage.shared.adapters.pagers;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.util.TypedValue;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.views.ImageTabView;

/**
 * Created by charlesx on 12/23/15.
 */
public class IconPagerAdapter extends FragmentPagerAdapter {

    private List<Fragment> mFragments;
    private List<Integer> mDrawables;
    private List<ImageTabView> mTabViews;
    private Context mContext;

    private float mMinAlpha;

    public IconPagerAdapter(FragmentManager fm, Context context) {
        super(fm);
        mFragments = new ArrayList<>();
        mDrawables = new ArrayList<>();
        mTabViews = new ArrayList<>();
        mContext = context;
        TypedValue value = new TypedValue();
        context.getResources().getValue(R.dimen.tabs_alpha, value, true);
        mMinAlpha = value.getFloat();
    }

    @Override
    public Fragment getItem(int position) { return mFragments.get(position); }

    @Override
    public int getCount() { return mFragments.size(); }

    public ImageTabView getTabView(int position) {
        return mTabViews.get(position);
    }

    public void addFragment(Fragment fragment, int drawableId) {
        mFragments.add(fragment);
        mDrawables.add(drawableId);

        ImageTabView tabView = new ImageTabView(mContext);
        tabView.setImage(drawableId);
        tabView.setImageAlpha(mMinAlpha);
        mTabViews.add(tabView);
    }
}
