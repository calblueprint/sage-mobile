package blueprint.com.sage.utility.model;

import blueprint.com.sage.shared.interfaces.BaseInterface;

/**
 * Created by charlesx on 1/30/16.
 */
public class SemesterUtils {

    public static boolean hasCurrentSemester(BaseInterface baseInterface) {
        return baseInterface.getCurrentSemester() != null;
    }

    public static boolean isPartOfCurrentSemester(BaseInterface baseInterface) {
        return hasCurrentSemester(baseInterface) &&
                baseInterface.getUser().getUserSemester() != null &&
                baseInterface.getUser().getUserSemester().getSemesterId() ==
                        baseInterface.getCurrentSemester().getId();
    }
}
