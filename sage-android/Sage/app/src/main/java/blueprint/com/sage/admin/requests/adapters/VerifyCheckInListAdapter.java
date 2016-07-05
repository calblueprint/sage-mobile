package blueprint.com.sage.admin.requests.adapters;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;
import java.util.TreeMap;

import blueprint.com.sage.R;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.network.Requests;
import butterknife.Bind;
import butterknife.ButterKnife;
import lombok.Data;

/**
 * Created by charlesx on 11/11/15.
 * Adapter for Check In lists
 */
public class VerifyCheckInListAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private Activity mActivity;
    private List<Item> mItems;

    private static final int HEADER_VIEW = 0;
    private static final int CHECK_IN_VIEW = 1;
    private final static String NO_SCHOOL = "No School";

    private final static String NEW_CHECK_INS = "New Check Ins";

    public VerifyCheckInListAdapter(Activity activity, List<CheckIn> checkIns) {
        super();
        mActivity = activity;
        setUpCheckIns(checkIns);
    }

    private void setUpCheckIns(List<CheckIn> checkIns) {
        mItems = new ArrayList<>();

        TreeMap<String, List<Item>> checkInMap = new TreeMap<>();

        for (CheckIn checkIn : checkIns) {
            if (checkIn.getSchool() == null) {
                if (!checkInMap.containsKey(NO_SCHOOL))
                    checkInMap.put(NO_SCHOOL, new ArrayList<Item>());
                checkInMap.get(NO_SCHOOL).add(new Item(checkIn, null));
                continue;
            }

            if (!checkInMap.containsKey(checkIn.getSchool().getName())) {
                checkInMap.put(checkIn.getSchool().getName(), new ArrayList<Item>());
            }
            checkInMap.get(checkIn.getSchool().getName()).add(new Item(checkIn, null));
        }

        for (String key : checkInMap.keySet()) {
            mItems.add(new Item(null, key));

            for (Item item : checkInMap.get(key))
                mItems.add(item);
        }
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view;
        switch (viewType) {
            case HEADER_VIEW:
                view = LayoutInflater.from(mActivity).inflate(R.layout.check_in_header_list_item, parent, false);
                return new HeaderViewHolder(view);
            case CHECK_IN_VIEW:
                view = LayoutInflater.from(mActivity).inflate(R.layout.verify_check_in_list_item, parent, false);
                return new CheckInViewHolder(view);
            default:
                Log.e(getClass().toString(), "Invalid viewHolder type");
                return null;
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, final int position) {
        if (getItemCount() == 0 || position < 0 || position >= getItemCount())
            return;

        Item item = mItems.get(position);

        if (item.isHeader()) {
            setUpHeaderViewHolder((HeaderViewHolder) viewHolder, item);
        } else {
            setUpCheckInViewHolder((CheckInViewHolder) viewHolder, item);
        }
    }

    private void setUpCheckInViewHolder(CheckInViewHolder viewHolder, final Item item) {
        final CheckIn checkIn = item.getCheckIn();

        viewHolder.mUser.setText(checkIn.getUser().getName());

        viewHolder.mTotalTime.setText(checkIn.getTotalTime());

        String comment = checkIn.getComment() == null || checkIn.getComment().isEmpty() ?
                "No Comment" : checkIn.getComment();
        viewHolder.mComment.setText(comment);

        viewHolder.mVerify.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                int position = mItems.indexOf(item);
                Requests.CheckIns.with(mActivity).makeVerifyRequest(checkIn, position);
            }
        });

        viewHolder.mDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                int position = mItems.indexOf(item);
                Requests.CheckIns.with(mActivity).makeDeleteRequest(checkIn, position);
            }
        });
    }

    private void setUpHeaderViewHolder(HeaderViewHolder viewHolder, Item item) {
        viewHolder.mHeaderText.setText(item.getHeader());
    }

    @Override
    public int getItemViewType(int position) {
        return mItems.get(position).isHeader() ? HEADER_VIEW : CHECK_IN_VIEW;
    }

    @Override
    public int getItemCount() { return mItems.size(); }

    public void setCheckIns(List<CheckIn> checkIns) {
        setUpCheckIns(checkIns);
        notifyDataSetChanged();
    }

    public void removeCheckIn(int position) {
        mItems.remove(position);
        notifyItemRemoved(position);
    }

    public void addNewCheckIn(CheckIn checkIn) {
        Item newCheckIn = new Item(checkIn, null);

        if (!hasNewCheckInHeader()) {
            Item newCheckInHeader = new Item(null, NEW_CHECK_INS);
            mItems.add(0, newCheckInHeader);
            mItems.add(1, newCheckIn);
            notifyItemRangeInserted(0, 2);
        } else {
            mItems.add(1, newCheckIn);
            notifyItemInserted(1);
        }
    }

    private boolean hasNewCheckInHeader() {
        return mItems != null &&
                mItems.size() > 0 &&
                mItems.get(0).isHeader() &&
                mItems.get(0).getHeader().equals(NEW_CHECK_INS);
    }

    public static class HeaderViewHolder extends RecyclerView.ViewHolder {
        @Bind(R.id.check_in_header_list_name) TextView mHeaderText;

        public HeaderViewHolder(View v) {
            super(v);
            ButterKnife.bind(this, v);
        }
    }

    public static class CheckInViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.verify_check_in_list_item_user) TextView mUser;
        @Bind(R.id.verify_check_in_list_item_total) TextView mTotalTime;
        @Bind(R.id.verify_check_in_list_item_comment) TextView mComment;
        @Bind(R.id.verify_check_in_list_item_verify) ImageButton mVerify;
        @Bind(R.id.verify_check_in_list_item_delete) ImageButton mDelete;

        public CheckInViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }

    @Data
    private static class Item {

        private CheckIn checkIn;
        private String header;

        public Item(CheckIn checkIn, String header) {
            this.checkIn = checkIn;
            this.header = header;
        }

        public boolean isHeader() {
            return header != null;
        }
    }
}
