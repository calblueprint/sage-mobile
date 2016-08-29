package blueprint.com.sage.shared;

/**
 * Created by charlesx on 2/28/16.
 */
public class PaginationInstance {
    private int mCurrentPage;

    public static PaginationInstance newInstance() { return new PaginationInstance(); }

    public PaginationInstance() { mCurrentPage = 0; }

    public int getCurrentPage() {return mCurrentPage; }

    public void incrementCurrentPage() {
        mCurrentPage++;
    }

    public boolean hasResetPage() { return mCurrentPage == 0; }

    public void resetPage() {
        mCurrentPage = 0;
    }
}
