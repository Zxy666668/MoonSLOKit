from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import PageBreak, Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "output" / "pdf" / "MoonSLOKit_项目申报书.pdf"
FONT = "C:/Windows/Fonts/msyh.ttc"


def main():
    pdfmetrics.registerFont(TTFont("MSYH", FONT))
    OUT.parent.mkdir(parents=True, exist_ok=True)
    styles = getSampleStyleSheet()
    title = ParagraphStyle("t", parent=styles["Title"], fontName="MSYH", fontSize=18, leading=24, textColor=colors.HexColor("#12355b"), alignment=1)
    h = ParagraphStyle("h", parent=styles["Heading2"], fontName="MSYH", fontSize=11.5, leading=15, textColor=colors.HexColor("#12355b"), spaceBefore=6, spaceAfter=4)
    body = ParagraphStyle("b", parent=styles["BodyText"], fontName="MSYH", fontSize=9.2, leading=13.2, spaceAfter=4)
    doc = SimpleDocTemplate(str(OUT), pagesize=A4, leftMargin=16 * mm, rightMargin=16 * mm, topMargin=14 * mm, bottomMargin=14 * mm)
    story = [Paragraph("MoonSLOKit 项目申报书", title), Spacer(1, 8)]
    data = [
        ["项目名称", "MoonSLOKit：面向 MoonBit 的 SLO、错误预算与多窗口燃烧率评估基础库"],
        ["参赛者", "周星宇"],
        ["联系方式", "19862933098"],
        ["GitHub 仓库", "https://github.com/Zxy666668/MoonSLOKit"],
        ["GitLink 仓库", "https://www.gitlink.org.cn/zxy66668/MoonSLOKit"],
        ["项目方向", "MoonBit 服务可靠性 / SLO / 错误预算基础设施"],
        ["是否移植", "否，原创 MoonBit 基础库项目"],
    ]
    table = Table(data, colWidths=[30 * mm, 132 * mm])
    table.setStyle(TableStyle([
        ("FONTNAME", (0, 0), (-1, -1), "MSYH"),
        ("FONTSIZE", (0, 0), (-1, -1), 8.5),
        ("BACKGROUND", (0, 0), (0, -1), colors.HexColor("#edf4fb")),
        ("TEXTCOLOR", (0, 0), (0, -1), colors.HexColor("#12355b")),
        ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#c9d6e2")),
        ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
        ("LEFTPADDING", (0, 0), (-1, -1), 6),
        ("RIGHTPADDING", (0, 0), (-1, -1), 6),
        ("TOPPADDING", (0, 0), (-1, -1), 4),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
    ]))
    story.append(table)
    story.append(Spacer(1, 8))
    for heading, text in [
        ("一、项目简介", "MoonSLOKit 面向 MoonBit 生态提供服务可靠性评估基础能力，围绕 SLO 目标、请求窗口、错误预算、燃烧率和多窗口告警决策建立可复用 API。"),
        ("二、核心功能", "项目已实现 SloTarget、RequestWindow、BudgetReport、BurnReport、BurnRule、AlertDecision、MultiWindowReport、JSON 导出和 CLI 演示。"),
        ("三、创新点和价值", "项目补足 MoonBit 在服务可靠性工程中的 SLO 数学层能力。它不采集指标、不存储时序数据，而是把已有请求计数转换为可审计的预算、燃烧率和告警决策，可用于 CI 门禁和监控面板。"),
        ("四、与社区项目差异", "社区已有 Web 框架、异步库、任务库、图表和数据处理项目。MoonSLOKit 只聚焦 SLO 目标、错误预算和 burn rate 语义，边界清晰，不与采集、存储、绘图或 HTTP 路由项目重合。"),
    ]:
        story.append(Paragraph(heading, h))
        story.append(Paragraph(text, body))
    story.append(PageBreak())
    for heading, text in [
        ("五、当前完成情况", "仓库包含 MoonBit 源码、8 个回归测试、CLI 示例、README、RELATED_WORK、ACCEPTANCE、CHANGELOG、GitHub Actions CI 和接口元数据。当前可运行 moon check --target all、moon test --target wasm、moon test --target wasm-gc 与 moon run cmd/main。"),
        ("六、技术路线", "项目以 basis point 表示 SLO 和错误率，避免浮点差异；以 RequestWindow 表示聚合请求窗口；以 BudgetReport 和 BurnReport 输出预算与燃烧率；以 BurnRule 和 MultiWindowReport 表达告警策略。"),
        ("七、验收与质量保障", "CI 使用官方 MoonBit 安装流程，并执行 check、test、fmt diff、moon info 和 CLI 演示。测试覆盖目标边界、可用性、预算消耗、燃烧率、多窗口告警和 JSON 输出。"),
        ("八、后续计划", "后续将补充更多标准告警模板、低流量保护、目标组合、SLO 日历窗口、决策快照对比和与可视化库/监控系统的对接示例。"),
        ("九、提交说明", "项目按 SLO 目标、预算、燃烧率、告警、多窗口、JSON、CLI、文档、CI、接口元数据和申报材料逐步提交，便于评审追踪开发过程。"),
    ]:
        story.append(Paragraph(heading, h))
        story.append(Paragraph(text, body))
    doc.build(story)


if __name__ == "__main__":
    main()
