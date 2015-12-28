package blueprint.com.sage.shared.adapters;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.content.ContextCompat;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.ImageSpan;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by charlesx on 12/23/15.
 */
public class IconPagerAdapter extends FragmentPagerAdapter {

    private List<Fragment> mFragments;
    private List<Integer> mDrawables;
    private Context mContext;

    public IconPagerAdapter(FragmentManager fm, Context context) {
        super(fm);
        mFragments = new ArrayList<>();
        mDrawables = new ArrayList<>();
        mContext = context;
    }

    @Override
    public Fragment getItem(int position) { return mFragments.get(position); }

    @Override
    public int getCount() { return mFragments.size(); }

    @Override
    public CharSequence getPageTitle(int position) {
        Drawable icon = ContextCompat.getDrawable(mContext, mDrawables.get(position));
        icon.setBounds(0, 0, icon.getIntrinsicWidth(), icon.getIntrinsicHeight());
        SpannableString sb = new SpannableString(" ");
        ImageSpan iconSpan = new ImageSpan(icon, ImageSpan.ALIGN_BOTTOM);
        sb.setSpan(iconSpan, 0, 1, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        return sb;
    }

    public void addFragment(Fragment fragment, int drawableId) {
        mFragments.add(fragment);
        mDrawables.add(drawableId);
    }
}
