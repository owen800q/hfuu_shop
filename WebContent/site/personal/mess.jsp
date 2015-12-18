<%/*
个人信息页，被/personal包含，非自己只显示公开信息
*/%>
<%
UserHandle userHandle=new UserHandle();
MessHandle messHandle= new MessHandle();
User user=null;
if(!LoginVerify.isLogin(request)){
    request.getRequestDispatcher("../../user/login.jsp?login-info="+java.net.URLEncoder.encode("你应该先登录，之后从个人中心进入消息页","UTF-8")).forward(request,response);
	return;
}
User me=(User)session.getAttribute("loginUser");

List<Mess> allMess = messHandle.findAllMessByUser(me);

%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@ page import="java.text.SimpleDateFormat,java.sql.*,src.dbHandle.*,src.tools.*,javax.servlet.http.HttpSession,java.util.*,src.vo.*"%>

<div class="panel panel-info">
	<div class="panel-heading">
<%
	String handle=request.getParameter("handle");
	Boolean isWrite=(handle!=null && handle.equals("write"))?true:false;
%>
<a href="<%=basePath%>user/personal.jsp?tab=mess&userid=<%=me.getId()%>">我的消息</a>
 / 
<a href="<%=basePath%>user/personal.jsp?tab=mess&handle=write&userid=<%=me.getId()%>">发送站内信</a>
	</div>
	<div class="panel-body">
<%if(!isWrite){%>
<div class="alert alert-warning" role="alert">
注意：系统消息会带有“sys”标签，其他皆为用户消息。
</div>
<!-- 这里写消息列表 -->
<%
if(allMess.size()!=0){
    
    for(int i=0;i<allMess.size();i++){
        Mess mess=allMess.get(i);
%>

<!-- 一条消息 -->	
<div onMouseOut="hide(this,'cz-bt-<%=i %>')" onMouseOver="show(this,'cz-bt-<%=i %>')" id="mess-<%=i %>" class="media">
  <div class="media-left">
    <a href="#">
      <img width="65px" class="media-object" 
      src="static/image/ac_31.png"<%//获取该用户头像 %>
       alt="sss">
    </a>
  </div>
  <div class="media-body">
    <span class="media-heading">
    <%user=userHandle.findById(mess.getMessFromId()); %>
    来自<a target="_blank" href="<%=basePath %>user/personal.jsp?tab=info&userid=<%=user.getId() %>">
    <%
    if(user.getName()==null || user.getName().length()==0){
        out.print(user.getEmail());
    }else{
        out.print(user.getName());
    }
    %>
    </a>，
    <%
	java.util.Date date=mess.getSendDate();
	SimpleDateFormat myFmt=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	String dateStr =myFmt.format(date);
	out.print(dateStr);
    %>
    </span>
    <div style="display:none" id="cz-bt-<%=i %>">
    <button type="button" class="btn btn-xs btn-success"
	onclick="window.open('<%=basePath%>user/personal.jsp?tab=mess&handle=write&toemail=<%=user.getEmail()%>%20==>%20<%=user.getName()%>&userid=<%=me.getId()%>')">回复</button><button type="button" class="btn btn-xs btn-danger"
	onclick="">删除此条消息</button>
    </div>
 
    <pre><%=mess.getMessText() %></pre>
  </div>
</div>
<!-- end of 一条消息 -->

<%}%>
<%}%>

<!-- end of 消息列表 -->
<%} else{ %>
<!-- 这里写消息发送页 -->
<div class="alert alert-warning" role="alert">
注意：消息发送成功后，对方将收到**站内消息**
</div>

<%
//提示
if(request.getParameter("info")!=null && !request.getParameter("info").equals("")){
%>
<div class="alert alert-warning" role="alert">
<%=request.getParameter("info") %>
</div>
<%}%>
<%
//邮箱自动填写
String toEmail="";
if(request.getParameter("toemail")!=null && !request.getParameter("toemail").equals("")){
    toEmail=request.getParameter("toemail");
}
%>

<form action="MessCheckServlet" method="post">
  <div class="form-group">
    <label for="InputEmail">发送给用户：</label>
    <input value="<%=toEmail%>" type="text" class="form-control" name="InputEmail" placeholder="输入用户邮箱">
  </div>
  <div class="form-group">
    <label for="InputMess">消息正文：</label>
    <textarea rows="5" class="form-control" name="InputMess" placeholder="输入消息正文"></textarea>
  </div>
  <button type="submit" class="btn btn-default">发送</button>
</form>
<!-- end of 消息发送页 -->
<%} %>
	</div>
</div>

<script>
function show(obj,id) {
var objDiv = $("#"+id+"");
$(objDiv).css("display","inline");
$(objDiv).css("left", event.clientX);
$(objDiv).css("top", event.clientY + 10);
}
function hide(obj,id) {
var objDiv = $("#"+id+"");
$(objDiv).css("display", "none");
}
</script> 