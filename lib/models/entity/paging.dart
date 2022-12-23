class Paging {
    Paging({
        this.page,
        this.size,
        this.total,
    });

    int? page;
    int? size;
    int? total;

    factory Paging.fromJson(Map<String, dynamic> json) => Paging(
        page: json["page"],
        size: json["size"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "size": size,
        "total": total,
    };
}