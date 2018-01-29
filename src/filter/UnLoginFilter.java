package filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

import static utils.Constant.loginPageUrl;

/**
 * Created by bill xu on 2018/1/5.
 * 登录过滤器  检查网页没有session就跳转回登录页面
 *http://blog.csdn.net/lsx991947534/article/details/45499205
 */
@WebFilter(filterName = "UnLoginFilter")
public class UnLoginFilter implements Filter {
    private static final String login_page = loginPageUrl;
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        HttpServletRequest request = (HttpServletRequest)req;
        HttpServletResponse response = (HttpServletResponse)resp;
        String currentURL = request.getRequestURI();//当前位置 /drugManager/index.jsp （去除主机and端口）
        String ctxPath = request.getContextPath(); //   /drugManager
        //除掉项目名称时访问页面当前路径
        String targetURL = currentURL.substring(ctxPath.length()); //  /index.jsp
        HttpSession session = request.getSession(false);
        //对当前页面进行判断，如果当前页面不为登录页面

        if(!("/index.jsp".equals(targetURL))){
            //在不为登陆页面时，再进行判断，如果不是登陆页面也没有session则跳转到登录页面，
            System.out.println("1 "+targetURL+" ctxPath: "+ctxPath+" currentURL: "+currentURL);
            System.out.println(session);
            if(session == null || session.getAttribute("account") == null){
                System.out.println("session不正确，回登录页面");
                response.sendRedirect(login_page);
            }else{
                System.out.println("正常跳转");
                //这里表示正确,用户已经登录，会去寻找下一个过滤器，如果不存在，则进行正常的页面跳转
                chain.doFilter(request, response);
            }
        }else{
            System.out.println("当前页是登录页面");
            //这里表示如果当前页面是登陆页面，跳转到登陆页面
            chain.doFilter(request, response);
        }
    }

    public void init(FilterConfig config) throws ServletException {

    }

}
