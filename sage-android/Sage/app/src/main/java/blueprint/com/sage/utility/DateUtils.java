package blueprint.com.sage.utility;

import org.joda.time.DateTime;
import org.joda.time.Period;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.util.Date;

/**
 * Created by charlesx on 10/30/15.
 * Date utilities.
 */
public class DateUtils {

    public static String DATE_FORMAT = "MMM dd, yyyy hh:mm a";
    public static String TIME_FORMAT = "hh:mm a";
    public static String DAY_FORMAT = "MMM dd, yyyy";

    public static String HOUR_FORMAT = "HH:mm";
    public static String YEAR_FORMAT = "yyyy/MM/dd";

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

    public static DateTime getDTTime(String dateTimeString) {
        return getDateTime(dateTimeString, TIME_FORMAT);
    }

    public static DateTime getDTHour(String dateTimeString) {
        return getDateTime(dateTimeString, HOUR_FORMAT);
    }

    public static DateTime getDTDate(String dateTimeString) {
        return getDateTime(dateTimeString, YEAR_FORMAT);
    }

    private static DateTime getDateTime(String dateTimeString, String format) {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(format);
        return formatter.parseDateTime(dateTimeString);
    }


    public static String getFormattedDate(DateTime dateTime) {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(DAY_FORMAT);
        return formatter.print(dateTime);
    }

    public static String getFormattedTime(DateTime dateTime) {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(TIME_FORMAT);
        return formatter.print(dateTime);
    }

    public static String getFormattedTimeNow() {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(DateUtils.DATE_FORMAT);
        return formatter.print(DateTime.now());
    }

    public static int getYear(Date date) {
        return (new DateTime(date)).getYear();
    }
}
