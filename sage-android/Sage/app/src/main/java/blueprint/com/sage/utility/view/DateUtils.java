package blueprint.com.sage.utility.view;

import org.joda.time.DateTime;
import org.joda.time.Period;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.util.Calendar;

/**
 * Created by charlesx on 10/30/15.
 * Date utilities.
 */
public class DateUtils {

    public static String DATE_FORMAT = "MMM dd, yyyy hh:mm a";
    public static String DATE_FORMAT_ABBREV = "MMM d, yyyy, h:mm a";
    public static String TIME_FORMAT = "hh:mm a";
    public static String DAY_FORMAT = "MMM dd, yyyy";

    public static String HOUR_FORMAT = "HH:mm";
    public static String YEAR_FORMAT = "yyyy/MM/dd";
    public static String ABBREV_YEAR_FORMAT = "MM/dd/yy";

    public static String PRESENT = "Present";

    public static DateTime stringToDate(String time) {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(DateUtils.DATE_FORMAT);
        return formatter.parseDateTime(time);
    }

    public static String dateToString(DateTime date) {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(DateUtils.DATE_FORMAT);
        return formatter.print(date);
    }

    public static String timeDiff(DateTime start, DateTime end) {
        Period period = new Period(start, end);

        int days = period.getDays();
        int hours = period.getHours() + 24 * days;
        int minutes = period.getMinutes();

        return String.format("%d hrs, %d min", hours, minutes);
    }

    public static DateTime getDateTime(String dateTimeString, String format) {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(format);
        return formatter.parseDateTime(dateTimeString);
    }

    public static String getFormattedDay(DateTime dateTime) {
        return forPattern(dateTime, DAY_FORMAT);

    }

    public static String getFormattedTime(DateTime dateTime) {
        return forPattern(dateTime, TIME_FORMAT);
    }

    public static String getFormattedDateNow() {
        return forPattern(DateTime.now(), DATE_FORMAT);
    }

    public static String getFormattedDateNow(String pattern) {
        return forPattern(DateTime.now(), pattern);
    }

    public static String forPattern(DateTime dateTime, String pattern) {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(pattern);
        return formatter.print(dateTime);
    }

    public static String getDateRange(DateTime start, DateTime finish, String pattern) {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(pattern);
        String startDate = formatter.print(start);
        String finishDate;
        if (finish != null) {
            finishDate = formatter.print(finish);
        } else {
            finishDate = DateUtils.PRESENT;
        }
        return startDate + " - " + finishDate;
    }

    public static String getDateRange(DateTime start, DateTime finish, String pattern) {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(pattern);
        String startDate = formatter.print(start);
        String finishDate;
        if (finish != null) {
            finishDate = formatter.print(finish);
        } else {
            finishDate = DateUtils.PRESENT;
        }
        return startDate + " - " + finishDate;
    }

    public static String getDateInAWeek() {
        Calendar now = Calendar.getInstance();
        now.add(Calendar.WEEK_OF_YEAR, 1);
        DateTime dateTime = new DateTime(now.getTime());
        return forPattern(dateTime, DateUtils.ABBREV_YEAR_FORMAT);
    }


}
