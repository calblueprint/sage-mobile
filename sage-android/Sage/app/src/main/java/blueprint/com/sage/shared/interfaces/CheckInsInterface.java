package blueprint.com.sage.shared.interfaces;

import java.util.List;

import blueprint.com.sage.models.CheckIn;

/**
 * Created by charlesx on 11/24/15.
 */
public interface CheckInsInterface {
    List<CheckIn> getCheckIns();
    void setCheckIns(List<CheckIn> checkIns);
    void getCheckInListRequest();
}
