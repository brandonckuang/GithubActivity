package ecs189.querying.github;

import ecs189.querying.Util;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Vincent on 10/1/2017.
 */
public class GithubQuerier {

    private static final String BASE_URL = "https://api.github.com/users/";
    private static final String token = "OMITTED"; //make sure you block this before pushing.

    public static String eventsAsHTML(String user) throws IOException, ParseException {
        List<JSONObject> response; // = getEvents(user);
        StringBuilder sb = new StringBuilder();
        sb.append("<div>");
        int i = 0;
        int pageNum = 1;
        do { 
            response = getEvents(user, pageNum);
            for (JSONObject event : response) {
                if (event.getString("type").equals("PushEvent") && i < 10) {
                    // Get event type
                    String type = event.getString("type");
                    // Get created_at date, and format it in a more pleasant style
                    String creationDate = event.getString("created_at");
                    SimpleDateFormat inFormat = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss'Z'");
                    SimpleDateFormat outFormat = new SimpleDateFormat("dd MMM, yyyy");
                    Date date = inFormat.parse(creationDate);
                    String formatted = outFormat.format(date);

                    // Add type of event as header
                    sb.append("<h3 class=\"type\">");
                    sb.append(type);
                    sb.append("</h3>");
                    // Add formatted date
                    sb.append(" on ");
                    sb.append(formatted);
                    sb.append("<br />"); //line break

                    JSONObject tempObject = event.getJSONObject("payload");
                    JSONArray tempArray = tempObject.getJSONArray("commits");
                    //JSONObject tempObject2 = tempArray.getJSONObject(0);
                    //System.out.println("Printing JSONARRAY" + tempArray);
                    //System.out.println("JSONarray Length" + tempArray.length());
                    if(tempArray.length() > 0){
                        for(int j = 0; j < tempArray.length(); j++) {
                            JSONObject tempObject2 = tempArray.getJSONObject(j);
                            String temp_sha = tempObject2.getString("sha").substring(0,7); //gets the SHA and cuts the length of string into 8 char
                            //System.out.println("SHA: " + temp_sha);
                            sb.append("<b> SHA: </b>" + temp_sha);
                            sb.append("<br />"); //line break
                            String temp_msg = tempObject2.getString("message");
                            sb.append("<b> Message: </b>" + temp_msg);
                            sb.append("<br />"); //line break
                            //For cleaner format
                            if(tempArray.length() > 1) {
                                sb.append("<br />"); //line break
                            }

                        }

                    }

                    // Add collapsible JSON textbox (don't worry about this for the homework; it's just a nice CSS thing I like)
                    sb.append("<a data-toggle=\"collapse\" href=\"#event-" + i + "\">JSON</a>");
                    sb.append("<div id=event-" + i + " class=\"collapse\" style=\"height: auto;\"> <pre>");
                    sb.append(event.toString());
                    sb.append("</pre> </div>");
                    i++;
                }
            }
            pageNum++;

        }while(!response.isEmpty());
        sb.append("</div>");
        return sb.toString();
    }

    private static List<JSONObject> getEvents(String user, int pageNumber) throws IOException {
        List<JSONObject> eventList = new ArrayList<JSONObject>();
        String url = BASE_URL + user + "/events?page=" + pageNumber + "&access_token=" + token;
        System.out.println(url);
        JSONObject json = Util.queryAPI(new URL(url));
        System.out.println(json);
        JSONArray events = json.getJSONArray("root");
        for (int i = 0; i < events.length() && i < 10; i++) {
            eventList.add(events.getJSONObject(i));
        }
        return eventList;
    }
}
