from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "output" / "pdf"
OUT.mkdir(parents=True, exist_ok=True)
PDF_PATH = OUT / "MoonSLOKit_项目申报书_增强版.pdf"

FONT = "Helvetica"
for candidate in [Path("C:/Windows/Fonts/msyh.ttc"), Path("C:/Windows/Fonts/simhei.ttf"), Path("C:/Windows/Fonts/simsun.ttc")]:
    if candidate.exists():
        pdfmetrics.registerFont(TTFont("CNFont", str(candidate)))
        FONT = "CNFont"
        break

styles = getSampleStyleSheet()
title = ParagraphStyle("TitleCN", parent=styles["Title"], fontName=FONT, fontSize=19, leading=25, textColor=colors.HexColor("#17395f"), alignment=1, spaceAfter=16)
section = ParagraphStyle("SectionCN", parent=styles["Heading2"], fontName=FONT, fontSize=12, leading=16, textColor=colors.HexColor("#17395f"), spaceBefore=7, spaceAfter=5)
body = ParagraphStyle("BodyCN", parent=styles["BodyText"], fontName=FONT, fontSize=9.4, leading=13.6, spaceAfter=5)
cell = ParagraphStyle("CellCN", parent=body, leading=13, spaceAfter=0)


def p(text, style=body):
    return Paragraph(text, style)


story = [p("MoonSLOKit 项目申报书", title)]
rows = [
    ("项目名称", "MoonSLOKit：面向 MoonBit 的 SLO、错误预算与多窗口燃烧率评估基础库"),
    ("参赛者", "周星宇"),
    ("联系方式", "19862933098"),
    ("GitHub 仓库", "https://github.com/Zxy666668/MoonSLOKit"),
    ("GitLink 仓库", "https://www.gitlink.org.cn/zxy66668/MoonSLOKit"),
    ("项目方向", "MoonBit 服务可靠性 / SLO / 错误预算 / 发布门禁基础设施"),
    ("是否移植", "否，原创 MoonBit 基础库项目"),
]
table = Table([[p(k, cell), p(v, cell)] for k, v in rows], colWidths=[34 * mm, 146 * mm])
table.setStyle(TableStyle([
    ("FONTNAME", (0, 0), (-1, -1), FONT),
    ("BACKGROUND", (0, 0), (0, -1), colors.HexColor("#eaf2fb")),
    ("TEXTCOLOR", (0, 0), (0, -1), colors.HexColor("#17395f")),
    ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#b7c8d8")),
    ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
    ("LEFTPADDING", (0, 0), (-1, -1), 7),
    ("RIGHTPADDING", (0, 0), (-1, -1), 7),
    ("TOPPADDING", (0, 0), (-1, -1), 5),
    ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
]))
story += [table, Spacer(1, 8)]

sections = [
    ("一、项目简介", "MoonSLOKit 面向 MoonBit 生态提供服务可靠性决策能力，围绕 SLO 目标、流量样本聚合、错误预算、燃烧率、多窗口告警、预算耗尽预测和发布门禁建立可复用 API。项目不做指标采集、存储或绘图，而是作为监控系统、CI 门禁、发布平台和服务治理工具可嵌入的 SLO 决策引擎。"),
    ("二、核心功能", "当前已实现 SloTarget、RequestWindow、TrafficSample、BudgetReport、BurnReport、BurnRule、MultiWindowReport、BudgetForecast、ReleaseGate、ServiceObjective、SloAnnotation、JSON 导出和 CLI 演示，覆盖从原始请求计数到发布决策的完整小型工作流。"),
    ("三、增强后的工作量", "针对预验收反馈，项目已从最小演示扩展为 15 个 MoonBit 源文件、18 个回归测试和多份验收文档。新增交通样本聚合、标准燃烧窗口模板、预算耗尽预测、CI 发布门禁、服务级评估、部署/事故注解和扩展 JSON 输出，明显提升工程深度。"),
    ("四、与社区项目差异", "项目不做 Web 框架、异步运行时、任务队列、图表、DataFrame、指标采集或日志系统。它专注 SLO 语义层和可靠性决策层，可与上述工具组合，但边界是错误预算、燃烧率、门禁和解释性报告。"),
    ("五、当前完成情况", "仓库包含 MoonBit 源码、18 个回归测试、CLI 示例、README、RELATED_WORK、ACCEPTANCE、CHANGELOG、GitHub Actions CI、接口元数据和本申报书。当前可运行 moon check --target all、moon test --target wasm、moon test --target wasm-gc、moon test --target js 与 moon run cmd/main。"),
    ("六、技术路线", "项目以 basis point 表达可用性和错误率，避免浮点差异；以 RequestWindow 表达聚合窗口；以 BurnRule 与 MultiWindowReport 表达告警策略；以 BudgetForecast 表达预算耗尽趋势；以 ReleaseGate 和 ServiceObjective 连接 CI、发布和服务治理场景。"),
    ("七、验收与质量保障", "CI 使用官方 MoonBit 安装流程，并执行 check、test、fmt diff、moon info diff 和 CLI 演示。测试覆盖目标边界、可用性、预算消耗、燃烧率、多窗口告警、样本聚合、预测、发布门禁、服务评估、注解和 JSON 输出。"),
    ("八、后续计划", "继续补充低流量保护、更多 Google SRE 风格多窗口策略、日历窗口、目标组合、决策快照对比、可视化适配示例和 benchmark 文档。"),
    ("九、提交说明", "项目已围绕公开仓库持续开发，每个新增模块均配套测试和提交记录，便于评审追踪从原型到增强版 SLO 决策库的演进过程。"),
]
for heading, text in sections:
    story += [p(heading, section), p(text)]

doc = SimpleDocTemplate(str(PDF_PATH), pagesize=A4, leftMargin=18 * mm, rightMargin=18 * mm, topMargin=18 * mm, bottomMargin=18 * mm)
doc.build(story)
print(PDF_PATH)
