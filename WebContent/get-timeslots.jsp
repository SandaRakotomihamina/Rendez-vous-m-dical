<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.RDVDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="org.json.JSONArray" %>

<%
    try {
        int medecinId = Integer.parseInt(request.getParameter("medecin_id"));
        String date = request.getParameter("date");
        
        List<String> timeslots = RDVDAO.getAvailableTimeslots(medecinId, date);
        JSONArray jsonArray = new JSONArray(timeslots);
        
        response.setContentType("application/json");
        out.print(jsonArray.toString());
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print("{\"error\": \"Erreur lors de la récupération des créneaux\"}");
    }
%>
